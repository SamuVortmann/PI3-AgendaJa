const agendamentoModel = require('../models/agendamentoModel');
const servicoModel = require('../models/servicoModel');
const profissionalModel = require('../models/profissionalModel');
const whatsappService = require('../services/whatsappService');
const { calcularHorariosLivres } = require('../services/disponibilidadeService');
const { formatarDataNoFuso } = require('../utils/dateTime');

const DUAS_HORAS_MS = 2 * 60 * 60 * 1000;

async function criar(req, res, next) {
  try {
    if (req.usuario.perfil !== 'cliente') {
      return res.status(403).json({ erro: 'Apenas clientes podem criar agendamentos' });
    }
    const { profissional_id: profissionalId, servico_id: servicoId, data_hora_inicio: inicio } =
      req.body || {};

    if (!profissionalId || !servicoId || !inicio) {
      return res.status(400).json({
        erro: 'profissional_id, servico_id e data_hora_inicio são obrigatórios',
      });
    }

    const servico = await servicoModel.findById(servicoId);
    if (!servico?.ativo) {
      return res.status(404).json({ erro: 'Serviço não encontrado' });
    }

    const profissional = await profissionalModel.findById(profissionalId);
    if (!profissional?.ativo) {
      return res.status(404).json({ erro: 'Profissional não encontrado' });
    }

    if (Number(profissional.empresa_id) !== Number(servico.empresa_id)) {
      return res.status(400).json({ erro: 'Profissional e serviço pertencem a empresas diferentes' });
    }

    const servicosDoProf = await profissionalModel.findServicosByProfissional(profissionalId);
    const atendeServico = servicosDoProf.some((s) => s.id === Number(servicoId));
    if (!atendeServico) {
      return res.status(400).json({ erro: 'Profissional não atende este serviço' });
    }

    const dataHoraInicio = new Date(inicio);
    if (Number.isNaN(dataHoraInicio.getTime())) {
      return res.status(400).json({ erro: 'Data e hora inválidas' });
    }
    const dataHoraFim = new Date(dataHoraInicio.getTime() + servico.duracao_minutos * 60000);

    if (dataHoraInicio <= new Date()) {
      return res.status(400).json({ erro: 'Não é possível agendar em horário passado' });
    }

    const dataLocal = formatarDataNoFuso(dataHoraInicio);
    const horariosLivres = await calcularHorariosLivres(profissionalId, servicoId, dataLocal);
    const horarioPermitido = horariosLivres.some(
      (slot) => new Date(slot.data_hora_inicio).getTime() === dataHoraInicio.getTime()
    );
    if (!horarioPermitido) {
      return res.status(409).json({ erro: 'Horário fora da disponibilidade do profissional' });
    }

    const conflito = await agendamentoModel.hasConflito(
      profissionalId,
      dataHoraInicio.toISOString(),
      dataHoraFim.toISOString()
    );

    if (conflito) {
      return res.status(409).json({ erro: 'Horário indisponível' });
    }

    const criado = await agendamentoModel.create({
      empresaId: servico.empresa_id,
      clienteId: req.usuario.id,
      profissionalId,
      servicoId,
      dataHoraInicio: dataHoraInicio.toISOString(),
      dataHoraFim: dataHoraFim.toISOString(),
    });

    const agendamentoCompleto = await agendamentoModel.findById(criado.id);

    try {
      await whatsappService.enviarConfirmacaoAgendamento(agendamentoCompleto);
    } catch (err) {
      console.error('WhatsApp confirmação:', err.message);
    }

    res.status(201).json(agendamentoCompleto);
  } catch (err) {
    next(err);
  }
}

async function meusAgendamentos(req, res, next) {
  try {
    const agendamentos = await agendamentoModel.findByCliente(req.usuario.id);
    res.json(agendamentos);
  } catch (err) {
    next(err);
  }
}

async function cancelar(req, res, next) {
  try {
    const { id } = req.params;
    const agendamento = await agendamentoModel.findById(id);

    if (!agendamento) {
      return res.status(404).json({ erro: 'Agendamento não encontrado' });
    }

    const isDono = Number(agendamento.cliente_id) === Number(req.usuario.id);
    const isAdmin = req.usuario.perfil === 'admin';

    if (!isDono && !isAdmin) {
      return res.status(403).json({ erro: 'Sem permissão para cancelar este agendamento' });
    }

    if (agendamento.status === 'cancelado') {
      return res.status(400).json({ erro: 'Agendamento já está cancelado' });
    }

    if (isDono && !isAdmin) {
      const tempoRestante = new Date(agendamento.data_hora_inicio) - new Date();
      if (tempoRestante < DUAS_HORAS_MS) {
        return res.status(400).json({
          erro: 'Cancelamento permitido apenas com pelo menos 2 horas de antecedência',
        });
      }
    }

    const atualizado = await agendamentoModel.updateStatus(id, 'cancelado');
    const completo = await agendamentoModel.findById(atualizado.id);
    res.json(completo);
  } catch (err) {
    next(err);
  }
}

module.exports = { criar, meusAgendamentos, cancelar };
