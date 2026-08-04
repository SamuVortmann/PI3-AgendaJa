const express = require('express');
const empresasController = require('../controllers/empresasController');
const { authenticate, loadUsuario } = require('../middlewares/auth');

const router = express.Router();

router.get('/', empresasController.listar);
router.get('/minha', authenticate, loadUsuario, empresasController.minha);
router.post('/', authenticate, loadUsuario, empresasController.criar);
router.put('/minha', authenticate, loadUsuario, empresasController.atualizar);
router.get('/:id', empresasController.buscar);

module.exports = router;
