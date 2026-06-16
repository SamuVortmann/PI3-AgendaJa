const { calcularHorariosLivres } = require('../services/disponibilidadeService');
const profissionalModel = require('../models/profissionalModel');

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
