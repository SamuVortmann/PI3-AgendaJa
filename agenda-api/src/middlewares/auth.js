const jwt = require('jsonwebtoken');
const usuarioModel = require('../models/usuarioModel');

function authenticate(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader?.startsWith('Bearer ')) {
    return res.status(401).json({ erro: 'Token de autenticação não informado' });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.usuario = decoded;
    next();
  } catch {
    return res.status(401).json({ erro: 'Token inválido ou expirado' });
  }
}

async function loadUsuario(req, res, next) {
  try {
    const usuario = await usuarioModel.findById(req.usuario.id);
    if (!usuario) {
      return res.status(401).json({ erro: 'Usuário não encontrado' });
    }
    req.usuario = usuario;
    next();
  } catch (err) {
    next(err);
  }
}

function requireAdmin(req, res, next) {
  if (!['admin', 'empresa'].includes(req.usuario.perfil)) {
    return res.status(403).json({ erro: 'Acesso restrito a gestores da empresa' });
  }
  if (req.usuario.perfil === 'empresa' && !req.usuario.empresa_id) {
    return res.status(403).json({ erro: 'Complete o cadastro da empresa para acessar esta área' });
  }
  next();
}

module.exports = { authenticate, loadUsuario, requireAdmin };
