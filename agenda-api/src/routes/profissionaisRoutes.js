const express = require('express');
const profissionaisController = require('../controllers/profissionaisController');

const router = express.Router();

router.get('/', profissionaisController.listarPorServico);

module.exports = router;
