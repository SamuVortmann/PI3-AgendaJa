const agendamentoModel = require('../models/agendamentoModel');
const servicoModel = require('../models/servicoModel');
const profissionalModel = require('../models/profissionalModel');
const disponibilidadeModel = require('../models/disponibilidadeModel');
const whatsappService = require('../services/whatsappService');

function parsePeriodo(query) {
  const { data_inicio: dataInicio, data_fim: dataFim, visao } = query;
  const hoje = new Date();
  hoje.setHours(0, 0, 0, 0);

  if (dataInicio && dataFim) {
    return { dataInicio, dataFim };
  }

  if (visao === 'semana') {
    const inicio = new Date(hoje);
    const fim = new Date(hoje);
    fim.setDate(fim.getDate() + 6);
    fim.setHours(23, 59, 59, 999);
    return { dataInicio: inicio.toISOString(), dataFim: fim.toISOString() };
  }

  const fimDia = new Date(hoje);
  fimDia.setHours(23, 59, 59, 999);
  return { dataInicio: hoje.toISOString(), dataFim: fimDia.toISOString() };
}

async function listarAgendamentos(req, res, next) {
  try {
    const { dataInicio, dataFim } = parsePeriodo(req.query);
    const { status } = req.query;

    const agendamentos = await agendamentoModel.findAll({ dataInicio, dataFim, status });
    res.json(agendamentos);
  } catch (err) {
    next(err);
  }
}

async function atualizarAgendamento(req, res, next) {
  try {
    const { id } = req.params;
    const { status, data_hora_inicio: novaDataInicio } = req.body;

    const agendamento = await agendamentoModel.findById(id);
    if (!agendamento) {
      return res.status(404).json({ erro: 'Agendamento não encontrado' });
    }

    if (novaDataInicio) {
      const servico = await servicoModel.findById(agendamento.servico_id);
      const inicio = new Date(novaDataInicio);
      const fim = new Date(inicio.getTime() + servico.duracao_minutos * 60000);

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
      await whatsappService.enviarConfirmacaoAgendamento(atualizado);
    }

    res.json(atualizado);
  } catch (err) {
    next(err);
  }
}

async function dashboard(req, res, next) {
  try {
    const totais = await agendamentoModel.contarPorPeriodo();
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
    const servicos = await servicoModel.findAll();
    res.json(servicos);
  } catch (err) {
    next(err);
  }
}

async function criarServico(req, res, next) {
  try {
    const { nome, descricao, duracao_minutos: duracaoMinutos, preco } = req.body;

    if (!nome || !duracaoMinutos || preco === undefined) {
      return res.status(400).json({ erro: 'Nome, duração e preço são obrigatórios' });
    }

    const servico = await servicoModel.create({
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
    const { nome, descricao, duracao_minutos: duracaoMinutos, preco, ativo } = req.body;
    const servico = await servicoModel.update(req.params.id, {
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
    const servico = await servicoModel.remove(req.params.id);
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
    const profissionais = await profissionalModel.findAll();
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
    const { nome, email, telefone, servico_ids: servicoIds } = req.body;

    if (!nome) {
      return res.status(400).json({ erro: 'Nome é obrigatório' });
    }

    const profissional = await profissionalModel.create({
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
    const { servico_ids: servicoIds, ...dados } = req.body;
    const profissional = await profissionalModel.update(req.params.id, {
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
    const profissional = await profissionalModel.remove(req.params.id);
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
    } = req.body;

    if (profissionalId === undefined || diaSemana === undefined || !horaInicio || !horaFim) {
      return res.status(400).json({
        erro: 'profissional_id, dia_semana, hora_inicio e hora_fim são obrigatórios',
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
    const disponibilidade = await disponibilidadeModel.update(req.params.id, {
      diaSemana: req.body.dia_semana,
      horaInicio: req.body.hora_inicio,
      horaFim: req.body.hora_fim,
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
