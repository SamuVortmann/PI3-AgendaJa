const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const usuarioModel = require('../models/usuarioModel');

function gerarToken(usuario) {
  return jwt.sign(
    {
      id: usuario.id,
      email: usuario.email,
      perfil: usuario.perfil,
    },
    process.env.JWT_SECRET,
    { expiresIn: '8h' }
  );
}

async function register(req, res, next) {
  try {
    const { nome, email, senha, telefone, perfil } = req.body;

    if (!nome || !email || !senha) {
      return res
        .status(400)
        .json({ erro: 'Nome, e-mail e senha são obrigatórios' });
    }

    const existente = await usuarioModel.findByEmail(email);

    if (existente) {
      return res.status(409).json({ erro: 'E-mail já cadastrado' });
    }

    const senhaHash = await bcrypt.hash(senha, 10);

    // Permite apenas os perfis esperados
    const perfilSeguro = perfil === 'admin' ? 'admin' : 'cliente';

    const usuario = await usuarioModel.create({
      nome,
      email,
      senhaHash,
      telefone,
      perfil: perfilSeguro,
    });

    const token = gerarToken(usuario);

    res.status(201).json({
      usuario,
      token,
    });
  } catch (err) {
    next(err);
  }
}

async function login(req, res, next) {
  try {
    const { email, senha } = req.body;

    if (!email || !senha) {
      return res
        .status(400)
        .json({ erro: 'E-mail e senha são obrigatórios' });
    }

    const usuario = await usuarioModel.findByEmail(email);

    if (!usuario) {
      return res.status(401).json({ erro: 'Credenciais inválidas' });
    }

    const senhaValida = await bcrypt.compare(senha, usuario.senha_hash);

    if (!senhaValida) {
      return res.status(401).json({ erro: 'Credenciais inválidas' });
    }

    const { senha_hash, ...usuarioSemSenha } = usuario;

    const token = gerarToken(usuarioSemSenha);

    res.json({
      usuario: usuarioSemSenha,
      token,
    });
  } catch (err) {
    next(err);
  }
}

async function me(req, res, next) {
  try {
    res.json(req.usuario);
  } catch (err) {
    next(err);
  }
}

module.exports = {
  register,
  login,
  me,
};