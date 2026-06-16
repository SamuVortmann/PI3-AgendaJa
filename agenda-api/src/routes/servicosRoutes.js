const express = require('express');
const servicosController = require('../controllers/servicosController');

const router = express.Router();

router.get('/', servicosController.listarAtivos);

module.exports = router;
