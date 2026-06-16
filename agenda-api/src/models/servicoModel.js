const pool = require('../../config/db');

async function findAllAtivos() {
  const result = await pool.query(
    'SELECT id, nome, descricao, duracao_minutos, preco, ativo FROM servicos WHERE ativo = TRUE ORDER BY nome'
  );
  return result.rows;
}

async function findAll() {
  const result = await pool.query(
    'SELECT id, nome, descricao, duracao_minutos, preco, ativo FROM servicos ORDER BY nome'
  );
  return result.rows;
}

async function findById(id) {
  const result = await pool.query(
    'SELECT id, nome, descricao, duracao_minutos, preco, ativo FROM servicos WHERE id = $1',
    [id]
  );
  return result.rows[0];
}

async function create({ nome, descricao, duracaoMinutos, preco }) {
  const result = await pool.query(
    `INSERT INTO servicos (nome, descricao, duracao_minutos, preco)
     VALUES ($1, $2, $3, $4)
     RETURNING id, nome, descricao, duracao_minutos, preco, ativo`,
    [nome, descricao || null, duracaoMinutos, preco]
  );
  return result.rows[0];
}

async function update(id, { nome, descricao, duracaoMinutos, preco, ativo }) {
  const result = await pool.query(
    `UPDATE servicos
     SET nome = COALESCE($2, nome),
         descricao = COALESCE($3, descricao),
         duracao_minutos = COALESCE($4, duracao_minutos),
         preco = COALESCE($5, preco),
         ativo = COALESCE($6, ativo)
     WHERE id = $1
     RETURNING id, nome, descricao, duracao_minutos, preco, ativo`,
    [id, nome, descricao, duracaoMinutos, preco, ativo]
  );
  return result.rows[0];
}

async function remove(id) {
  const result = await pool.query(
    'UPDATE servicos SET ativo = FALSE WHERE id = $1 RETURNING id',
    [id]
  );
  return result.rows[0];
}

module.exports = { findAllAtivos, findAll, findById, create, update, remove };
