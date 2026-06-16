const express = require('express');
const agendamentosController = require('../controllers/agendamentosController');
const { authenticate, loadUsuario } = require('../middlewares/auth');

const router = express.Router();

router.post('/', authenticate, loadUsuario, agendamentosController.criar);
router.get('/meus', authenticate, loadUsuario, agendamentosController.meusAgendamentos);
router.delete('/:id', authenticate, loadUsuario, agendamentosController.cancelar);

module.exports = router;
