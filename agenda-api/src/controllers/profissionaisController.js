const profissionalModel = require('../models/profissionalModel');

async function listarPorServico(req, res, next) {
  try {
    const { servico_id: servicoId } = req.query;

    if (!servicoId) {
      return res.status(400).json({ erro: 'Parâmetro servico_id é obrigatório' });
    }

    const profissionais = await profissionalModel.findByServico(servicoId);
    res.json(profissionais);
  } catch (err) {
    next(err);
  }
}

module.exports = { listarPorServico };
