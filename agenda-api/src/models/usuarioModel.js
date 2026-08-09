const pool = require('../../config/db');

async function findByEmail(email) {
  const result = await pool.query(
    `SELECT u.id, u.nome, u.email, u.senha_hash, u.telefone, u.perfil, u.criado_em,
            e.id AS empresa_id, e.nome AS empresa_nome
     FROM usuarios u
     LEFT JOIN empresas e ON e.usuario_id = u.id
     WHERE u.email = $1`,
    [email]
  );
  return result.rows[0];
}

async function findById(id) {
  const result = await pool.query(
    `SELECT u.id, u.nome, u.email, u.telefone, u.perfil, u.criado_em,
            e.id AS empresa_id, e.nome AS empresa_nome
     FROM usuarios u
     LEFT JOIN empresas e ON e.usuario_id = u.id
     WHERE u.id = $1`,
    [id]
  );
  return result.rows[0];
}

async function create({ nome, email, senhaHash, telefone, perfil = 'cliente' }) {
  const result = await pool.query(
    `INSERT INTO usuarios (nome, email, senha_hash, telefone, perfil)
     VALUES ($1, $2, $3, $4, $5)
     RETURNING id, nome, email, telefone, perfil, criado_em`,
    [nome, email, senhaHash, telefone || null, perfil]
  );
  return result.rows[0];
}

async function updateProfile(id, { nome, telefone }) {
  const result = await pool.query(
    `UPDATE usuarios
     SET nome = $2, telefone = $3
     WHERE id = $1
     RETURNING id, nome, email, telefone, perfil, criado_em`,
    [id, nome, telefone || null]
  );
  return result.rows[0];
}

module.exports = { findByEmail, findById, create, updateProfile };
