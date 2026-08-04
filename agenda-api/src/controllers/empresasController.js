const empresaModel = require('../models/empresaModel');

function validarDados(body, parcial = false) {
  const { nome, endereco, telefone, dias_funcionamento: dias, hora_abertura: abertura, hora_fechamento: fechamento } = body;
  if (!parcial && (!nome || !endereco || !telefone)) {
    return 'Nome, endereco e telefone sao obrigatorios';
  }
  if (dias !== undefined && (!Array.isArray(dias) || dias.some((dia) => !Number.isInteger(dia) || dia < 0 || dia > 6))) {
    return 'dias_funcionamento deve conter numeros de 0 a 6';
  }
  if (abertura && fechamento && abertura >= fechamento) {
    return 'O horario de fechamento deve ser posterior ao de abertura';
  }
  return null;
}

async function listar(req, res, next) {
  try {
    res.json(await empresaModel.findAllAtivas());
  } catch (err) {
    next(err);
  }
}

async function buscar(req, res, next) {
  try {
    const empresa = await empresaModel.findById(req.params.id);
    if (!empresa?.ativo) return res.status(404).json({ erro: 'Empresa nao encontrada' });
    res.json(empresa);
  } catch (err) {
    next(err);
  }
}

async function minha(req, res, next) {
  try {
    const empresa = await empresaModel.findByUsuarioId(req.usuario.id);
    if (!empresa) return res.status(404).json({ erro: 'Cadastro da empresa nao encontrado' });
    res.json(empresa);
  } catch (err) {
    next(err);
  }
}

async function criar(req, res, next) {
  try {
    if (req.usuario.perfil !== 'empresa') {
      return res.status(403).json({ erro: 'Apenas contas de empresa podem cadastrar uma empresa' });
    }
    const existente = await empresaModel.findByUsuarioId(req.usuario.id);
    if (existente) return res.status(409).json({ erro: 'Esta conta ja possui uma empresa' });
    const erro = validarDados(req.body || {});
    if (erro) return res.status(400).json({ erro });

    const body = req.body;
    const empresa = await empresaModel.create({
      usuarioId: req.usuario.id,
      nome: body.nome,
      cnpj: body.cnpj,
      endereco: body.endereco,
      telefone: body.telefone,
      diasFuncionamento: body.dias_funcionamento,
      horaAbertura: body.hora_abertura,
      horaFechamento: body.hora_fechamento,
    });
    res.status(201).json(empresa);
  } catch (err) {
    next(err);
  }
}

async function atualizar(req, res, next) {
  try {
    if (req.usuario.perfil !== 'empresa') {
      return res.status(403).json({ erro: 'Apenas contas de empresa podem alterar estes dados' });
    }
    const erro = validarDados(req.body || {}, true);
    if (erro) return res.status(400).json({ erro });
    const body = req.body || {};
    const empresa = await empresaModel.updateByUsuarioId(req.usuario.id, {
      nome: body.nome,
      cnpj: body.cnpj,
      endereco: body.endereco,
      telefone: body.telefone,
      diasFuncionamento: body.dias_funcionamento,
      horaAbertura: body.hora_abertura,
      horaFechamento: body.hora_fechamento,
    });
    if (!empresa) return res.status(404).json({ erro: 'Cadastro da empresa nao encontrado' });
    res.json(empresa);
  } catch (err) {
    next(err);
  }
}

module.exports = { listar, buscar, minha, criar, atualizar };
