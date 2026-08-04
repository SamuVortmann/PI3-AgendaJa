const servicoModel = require('../models/servicoModel');

async function listarAtivos(req, res, next) {
  try {
    const empresaId = req.query.empresa_id ? Number(req.query.empresa_id) : null;
    const servicos = await servicoModel.findAllAtivos(empresaId);
    res.json(servicos);
  } catch (err) {
    next(err);
  }
}

module.exports = { listarAtivos };
