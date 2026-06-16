const express = require('express');
const adminController = require('../controllers/adminController');
const { authenticate, loadUsuario, requireAdmin } = require('../middlewares/auth');

const router = express.Router();

router.use(authenticate, loadUsuario, requireAdmin);

router.get('/dashboard', adminController.dashboard);

router.get('/agendamentos', adminController.listarAgendamentos);
router.put('/agendamentos/:id', adminController.atualizarAgendamento);

router.get('/servicos', adminController.listarServicos);
router.post('/servicos', adminController.criarServico);
router.put('/servicos/:id', adminController.atualizarServico);
router.delete('/servicos/:id', adminController.excluirServico);

router.get('/profissionais', adminController.listarProfissionais);
router.post('/profissionais', adminController.criarProfissional);
router.put('/profissionais/:id', adminController.atualizarProfissional);
router.delete('/profissionais/:id', adminController.excluirProfissional);

router.get('/disponibilidades', adminController.listarDisponibilidades);
router.post('/disponibilidades', adminController.criarDisponibilidade);
router.put('/disponibilidades/:id', adminController.atualizarDisponibilidade);
router.delete('/disponibilidades/:id', adminController.excluirDisponibilidade);

module.exports = router;
