const servicoModel = require('../models/servicoModel');

async function listarAtivos(req, res, next) {
  try {
    const servicos = await servicoModel.findAllAtivos();
    res.json(servicos);
  } catch (err) {
    next(err);
  }
}

module.exports = { listarAtivos };
