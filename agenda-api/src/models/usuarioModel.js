const pool = require('../../config/db');

async function findByEmail(email) {
  const result = await pool.query(
    'SELECT id, nome, email, senha_hash, telefone, perfil, criado_em FROM usuarios WHERE email = $1',
    [email]
  );
  return result.rows[0];
}

async function findById(id) {
  const result = await pool.query(
    'SELECT id, nome, email, telefone, perfil, criado_em FROM usuarios WHERE id = $1',
    [id]
  );
  return result.rows[0];
}

async function create({ nome, email, senhaHash, telefone }) {
  const result = await pool.query(
    `INSERT INTO usuarios (nome, email, senha_hash, telefone, perfil)
     VALUES ($1, $2, $3, $4, 'cliente')
     RETURNING id, nome, email, telefone, perfil, criado_em`,
    [nome, email, senhaHash, telefone || null]
  );
  return result.rows[0];
}

module.exports = { findByEmail, findById, create };
