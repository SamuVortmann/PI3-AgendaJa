const express = require('express');
const authController = require('../controllers/authController');
const { authenticate, loadUsuario } = require('../middlewares/auth');

const router = express.Router();

router.post('/register', authController.register);
router.post('/login', authController.login);
router.get('/me', authenticate, loadUsuario, authController.me);
router.put('/me', authenticate, loadUsuario, authController.atualizarPerfil);

module.exports = router;
