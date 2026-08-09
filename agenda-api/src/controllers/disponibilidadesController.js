const { calcularHorariosLivres } = require('../services/disponibilidadeService');
const profissionalModel = require('../models/profissionalModel');
const servicoModel = require('../models/servicoModel');
const { validarDataIso } = require('../utils/dateTime');

async function listarHorariosLivres(req, res, next) {
  try {
    const { profissional_id: profissionalId, servico_id: servicoId, data } = req.query;

    if (!profissionalId || !servicoId || !data) {
      return res.status(400).json({
        erro: 'Parâmetros profissional_id, servico_id e data são obrigatórios',
      });
    }

    const profissional = await profissionalModel.findById(profissionalId);
    if (!profissional?.ativo) {
      return res.status(404).json({ erro: 'Profissional não encontrado' });
    }
    if (!validarDataIso(data)) {
      return res.status(400).json({ erro: 'Data inválida. Use o formato AAAA-MM-DD' });
    }
    const servico = await servicoModel.findById(servicoId);
    if (!servico?.ativo || Number(servico.empresa_id) !== Number(profissional.empresa_id)) {
      return res.status(404).json({ erro: 'Serviço não encontrado para este profissional' });
    }
    const servicos = await profissionalModel.findServicosByProfissional(profissionalId);
    if (!servicos.some((item) => Number(item.id) === Number(servicoId))) {
      return res.status(400).json({ erro: 'O profissional não atende a este serviço' });
    }

    const horarios = await calcularHorariosLivres(
      Number(profissionalId),
      Number(servicoId),
      data
    );

    res.json({ data, profissional_id: Number(profissionalId), horarios });
  } catch (err) {
    next(err);
  }
}

module.exports = { listarHorariosLivres };
