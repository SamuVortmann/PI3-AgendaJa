const express = require('express');
const disponibilidadesController = require('../controllers/disponibilidadesController');

const router = express.Router();

router.get('/', disponibilidadesController.listarHorariosLivres);

module.exports = router;
