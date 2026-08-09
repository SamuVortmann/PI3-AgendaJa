const agendamentoModel = require('../models/agendamentoModel');
const servicoModel = require('../models/servicoModel');
const profissionalModel = require('../models/profissionalModel');
const disponibilidadeModel = require('../models/disponibilidadeModel');
const whatsappService = require('../services/whatsappService');
const { calcularHorariosLivres } = require('../services/disponibilidadeService');
const {
  adicionarDias,
  formatarDataNoFuso,
  validarDataIso,
  validarHorario,
} = require('../utils/dateTime');

function empresaDoGestor(req) {
  return req.usuario.empresa_id || null;
}

function empresaParaCriacao(req) {
  return empresaDoGestor(req) || Number(req.body?.empresa_id) || null;
}

function parsePeriodo(query) {
  const { data_inicio: dataInicio, data_fim: dataFim, visao } = query;

  if ((dataInicio && !dataFim) || (!dataInicio && dataFim)) {
    return { erro: 'Informe data_inicio e data_fim em conjunto' };
  }

  if (dataInicio && dataFim) {
    if (!validarDataIso(dataInicio) || !validarDataIso(dataFim) || dataInicio > dataFim) {
      return { erro: 'Período de datas inválido' };
    }
    return { dataInicio, dataFim };
  }

  const hoje = formatarDataNoFuso(new Date());

  if (visao === 'todos') {
    return { dataInicio: null, dataFim: null };
  }

  if (visao === 'semana') {
    const diaSemana = new Date(`${hoje}T12:00:00Z`).getUTCDay();
    const diasDesdeSegunda = (diaSemana + 6) % 7;
    const inicioSemana = adicionarDias(hoje, -diasDesdeSegunda);
    return {
      dataInicio: inicioSemana,
      dataFim: adicionarDias(inicioSemana, 6),
    };
  }

  return {
    dataInicio: hoje,
    dataFim: hoje,
  };
}

function validarFaixaDisponibilidade(diaSemana, horaInicio, horaFim) {
  const dia = Number(diaSemana);
  const inicio = horaInicio?.slice(0, 5);
  const fim = horaFim?.slice(0, 5);
  if (!Number.isInteger(dia) || dia < 0 || dia > 6) return 'Dia da semana inválido';
  if (!validarHorario(inicio) || !validarHorario(fim)) return 'Horários inválidos';
  if (inicio >= fim) return 'O horário final deve ser posterior ao inicial';
  return null;
}

async function servicosPertencemAEmpresa(servicoIds, empresaId) {
  const servicos = await Promise.all(servicoIds.map((id) => servicoModel.findById(id)));
  return servicos.every(
    (servico) => servico && (!empresaId || Number(servico.empresa_id) === Number(empresaId))
  );
}

async function listarAgendamentos(req, res, next) {
  try {
    const periodo = parsePeriodo(req.query);
    if (periodo.erro) return res.status(400).json({ erro: periodo.erro });
    const { status } = req.query;
    if (status && !['pendente', 'confirmado', 'cancelado'].includes(status)) {
      return res.status(400).json({ erro: 'Status inválido' });
    }

    const agendamentos = await agendamentoModel.findAll({
      dataInicio: periodo.dataInicio,
      dataFim: periodo.dataFim,
      status,
      empresaId: empresaDoGestor(req),
    });
    res.json(agendamentos);
  } catch (err) {
    next(err);
  }
}

async function atualizarAgendamento(req, res, next) {
  try {
    const { id } = req.params;
    const { status, data_hora_inicio: novaDataInicio } = req.body || {};

    const agendamento = await agendamentoModel.findById(id);
    if (!agendamento) {
      return res.status(404).json({ erro: 'Agendamento não encontrado' });
    }
    const empresaId = empresaDoGestor(req);
    if (empresaId && Number(agendamento.empresa_id) !== Number(empresaId)) {
      return res.status(404).json({ erro: 'Agendamento não encontrado' });
    }

    if (novaDataInicio) {
      const servico = await servicoModel.findById(agendamento.servico_id);
      const inicio = new Date(novaDataInicio);
      if (Number.isNaN(inicio.getTime()) || inicio <= new Date()) {
        return res.status(400).json({ erro: 'Informe uma data futura válida' });
      }
      const fim = new Date(inicio.getTime() + servico.duracao_minutos * 60000);

      const dataLocal = formatarDataNoFuso(inicio);
      const horariosLivres = await calcularHorariosLivres(
        agendamento.profissional_id,
        agendamento.servico_id,
        dataLocal,
        id
      );
      const horarioPermitido = horariosLivres.some(
        (slot) => new Date(slot.data_hora_inicio).getTime() === inicio.getTime()
      );
      if (!horarioPermitido) {
        return res.status(409).json({ erro: 'Horário fora da disponibilidade do profissional' });
      }

      const conflito = await agendamentoModel.hasConflito(
        agendamento.profissional_id,
        inicio.toISOString(),
        fim.toISOString(),
        id
      );

      if (conflito) {
        return res.status(409).json({ erro: 'Horário indisponível para reagendamento' });
      }

      await agendamentoModel.reagendar(id, {
        dataHoraInicio: inicio.toISOString(),
        dataHoraFim: fim.toISOString(),
      });
    } else if (status) {
      const statusValidos = ['pendente', 'confirmado', 'cancelado'];
      if (!statusValidos.includes(status)) {
        return res.status(400).json({ erro: 'Status inválido' });
      }
      await agendamentoModel.updateStatus(id, status);
    } else {
      return res.status(400).json({ erro: 'Informe status ou data_hora_inicio' });
    }

    const atualizado = await agendamentoModel.findById(id);

    if (novaDataInicio) {
      await whatsappService.enviarNotificacaoReagendamento(atualizado);
    }

    res.json(atualizado);
  } catch (err) {
    next(err);
  }
}

async function dashboard(req, res, next) {
  try {
    const totais = await agendamentoModel.contarPorPeriodo(empresaDoGestor(req));
    res.json({
      agendamentos_hoje: Number(totais.hoje),
      agendamentos_semana: Number(totais.semana),
      agendamentos_mes: Number(totais.mes),
    });
  } catch (err) {
    next(err);
  }
}

async function listarServicos(req, res, next) {
  try {
    const servicos = await servicoModel.findAll(empresaDoGestor(req));
    res.json(servicos);
  } catch (err) {
    next(err);
  }
}

async function criarServico(req, res, next) {
  try {
    const { nome, descricao, duracao_minutos: duracaoMinutos, preco } = req.body || {};

    if (
      !nome ||
      !Number.isInteger(Number(duracaoMinutos)) ||
      Number(duracaoMinutos) <= 0 ||
      !Number.isFinite(Number(preco)) ||
      Number(preco) < 0
    ) {
      return res.status(400).json({ erro: 'Nome, duração e preço são obrigatórios' });
    }

    const empresaId = empresaParaCriacao(req);
    if (!empresaId) {
      return res.status(400).json({ erro: 'empresa_id é obrigatório' });
    }

    const servico = await servicoModel.create({
      empresaId,
      nome,
      descricao,
      duracaoMinutos,
      preco,
    });
    res.status(201).json(servico);
  } catch (err) {
    next(err);
  }
}

async function atualizarServico(req, res, next) {
  try {
    const { nome, descricao, duracao_minutos: duracaoMinutos, preco, ativo } = req.body || {};
    if (nome !== undefined && !String(nome).trim()) {
      return res.status(400).json({ erro: 'O nome não pode ficar vazio' });
    }
    if (
      duracaoMinutos !== undefined &&
      (!Number.isInteger(Number(duracaoMinutos)) || Number(duracaoMinutos) <= 0)
    ) {
      return res.status(400).json({ erro: 'Duração inválida' });
    }
    if (preco !== undefined && (!Number.isFinite(Number(preco)) || Number(preco) < 0)) {
      return res.status(400).json({ erro: 'Preço inválido' });
    }
    const servico = await servicoModel.update(req.params.id, empresaDoGestor(req), {
      nome,
      descricao,
      duracaoMinutos,
      preco,
      ativo,
    });
    if (!servico) {
      return res.status(404).json({ erro: 'Serviço não encontrado' });
    }
    res.json(servico);
  } catch (err) {
    next(err);
  }
}

async function excluirServico(req, res, next) {
  try {
    const servico = await servicoModel.remove(req.params.id, empresaDoGestor(req));
    if (!servico) {
      return res.status(404).json({ erro: 'Serviço não encontrado' });
    }
    res.json({ mensagem: 'Serviço desativado com sucesso' });
  } catch (err) {
    next(err);
  }
}

async function listarProfissionais(req, res, next) {
  try {
    const profissionais = await profissionalModel.findAll(empresaDoGestor(req));
    const comServicos = await Promise.all(
      profissionais.map(async (p) => ({
        ...p,
        servicos: await profissionalModel.findServicosByProfissional(p.id),
      }))
    );
    res.json(comServicos);
  } catch (err) {
    next(err);
  }
}

async function criarProfissional(req, res, next) {
  try {
    const { nome, email, telefone, servico_ids: servicoIds } = req.body || {};

    if (!nome || !Array.isArray(servicoIds) || servicoIds.length === 0) {
      return res.status(400).json({ erro: 'O nome e ao menos um serviço são obrigatórios' });
    }
    const empresaId = empresaParaCriacao(req);
    if (!empresaId) {
      return res.status(400).json({ erro: 'empresa_id é obrigatório' });
    }
    if (!(await servicosPertencemAEmpresa(servicoIds, empresaId))) {
      return res.status(400).json({ erro: 'Um ou mais serviços não pertencem à empresa' });
    }

    const profissional = await profissionalModel.create({
      empresaId,
      nome,
      email,
      telefone,
      servicoIds,
    });
    res.status(201).json(profissional);
  } catch (err) {
    next(err);
  }
}

async function atualizarProfissional(req, res, next) {
  try {
    const { servico_ids: servicoIds, ...dados } = req.body || {};
    if (dados.nome !== undefined && !String(dados.nome).trim()) {
      return res.status(400).json({ erro: 'O nome não pode ficar vazio' });
    }
    if (servicoIds !== undefined && (!Array.isArray(servicoIds) || servicoIds.length === 0)) {
      return res.status(400).json({ erro: 'Selecione ao menos um serviço' });
    }
    if (
      servicoIds !== undefined &&
      !(await servicosPertencemAEmpresa(servicoIds, empresaDoGestor(req)))
    ) {
      return res.status(400).json({ erro: 'Um ou mais serviços não pertencem à empresa' });
    }
    const profissional = await profissionalModel.update(req.params.id, empresaDoGestor(req), {
      ...dados,
      servicoIds,
    });

    if (!profissional) {
      return res.status(404).json({ erro: 'Profissional não encontrado' });
    }

    const servicos = await profissionalModel.findServicosByProfissional(profissional.id);
    res.json({ ...profissional, servicos });
  } catch (err) {
    next(err);
  }
}

async function excluirProfissional(req, res, next) {
  try {
    const profissional = await profissionalModel.remove(req.params.id, empresaDoGestor(req));
    if (!profissional) {
      return res.status(404).json({ erro: 'Profissional não encontrado' });
    }
    res.json({ mensagem: 'Profissional desativado com sucesso' });
  } catch (err) {
    next(err);
  }
}

async function listarDisponibilidades(req, res, next) {
  try {
    const { profissional_id: profissionalId } = req.query;

    if (!profissionalId) {
      return res.status(400).json({ erro: 'profissional_id é obrigatório' });
    }
    const profissional = await profissionalModel.findById(profissionalId);
    const empresaId = empresaDoGestor(req);
    if (!profissional || (empresaId && Number(profissional.empresa_id) !== Number(empresaId))) {
      return res.status(404).json({ erro: 'Profissional não encontrado' });
    }

    const disponibilidades = await disponibilidadeModel.findByProfissional(profissionalId);
    res.json(disponibilidades);
  } catch (err) {
    next(err);
  }
}

async function criarDisponibilidade(req, res, next) {
  try {
    const {
      profissional_id: profissionalId,
      dia_semana: diaSemana,
      hora_inicio: horaInicio,
      hora_fim: horaFim,
    } = req.body || {};

    if (profissionalId === undefined || diaSemana === undefined || !horaInicio || !horaFim) {
      return res.status(400).json({
        erro: 'profissional_id, dia_semana, hora_inicio e hora_fim são obrigatórios',
      });
    }
    const erroFaixa = validarFaixaDisponibilidade(diaSemana, horaInicio, horaFim);
    if (erroFaixa) return res.status(400).json({ erro: erroFaixa });
    const profissional = await profissionalModel.findById(profissionalId);
    const empresaId = empresaDoGestor(req);
    if (!profissional || (empresaId && Number(profissional.empresa_id) !== Number(empresaId))) {
      return res.status(404).json({ erro: 'Profissional não encontrado' });
    }

    if (await disponibilidadeModel.hasConflito(profissionalId, diaSemana, horaInicio, horaFim)) {
      return res.status(409).json({
        erro: 'Esta faixa de horário conflita com outra disponibilidade',
      });
    }
    const disponibilidade = await disponibilidadeModel.create({
      profissionalId,
      diaSemana,
      horaInicio,
      horaFim,
    });
    res.status(201).json(disponibilidade);
  } catch (err) {
    next(err);
  }
}

async function atualizarDisponibilidade(req, res, next) {
  try {
    const atual = await disponibilidadeModel.findById(req.params.id);
    const empresaId = empresaDoGestor(req);
    if (!atual || (empresaId && Number(atual.empresa_id) !== Number(empresaId))) {
      return res.status(404).json({ erro: 'Disponibilidade não encontrada' });
    }
    const body = req.body || {};
    const diaSemana = body.dia_semana ?? atual.dia_semana;
    const horaInicio = body.hora_inicio ?? atual.hora_inicio;
    const horaFim = body.hora_fim ?? atual.hora_fim;
    const erroFaixa = validarFaixaDisponibilidade(diaSemana, horaInicio, horaFim);
    if (erroFaixa) return res.status(400).json({ erro: erroFaixa });
    if (
      await disponibilidadeModel.hasConflito(
        atual.profissional_id,
        diaSemana,
        horaInicio,
        horaFim,
        req.params.id
      )
    ) {
      return res.status(409).json({
        erro: 'Esta faixa de horário conflita com outra disponibilidade',
      });
    }
    const disponibilidade = await disponibilidadeModel.update(req.params.id, {
      diaSemana,
      horaInicio,
      horaFim,
    });

    if (!disponibilidade) {
      return res.status(404).json({ erro: 'Disponibilidade não encontrada' });
    }

    res.json(disponibilidade);
  } catch (err) {
    next(err);
  }
}

async function excluirDisponibilidade(req, res, next) {
  try {
    const atual = await disponibilidadeModel.findById(req.params.id);
    const empresaId = empresaDoGestor(req);
    if (!atual || (empresaId && Number(atual.empresa_id) !== Number(empresaId))) {
      return res.status(404).json({ erro: 'Disponibilidade não encontrada' });
    }
    const disponibilidade = await disponibilidadeModel.remove(req.params.id);
    if (!disponibilidade) {
      return res.status(404).json({ erro: 'Disponibilidade não encontrada' });
    }
    res.json({ mensagem: 'Disponibilidade removida com sucesso' });
  } catch (err) {
    next(err);
  }
}

module.exports = {
  listarAgendamentos,
  atualizarAgendamento,
  dashboard,
  listarServicos,
  criarServico,
  atualizarServico,
  excluirServico,
  listarProfissionais,
  criarProfissional,
  atualizarProfissional,
  excluirProfissional,
  listarDisponibilidades,
  criarDisponibilidade,
  atualizarDisponibilidade,
  excluirDisponibilidade,
};
