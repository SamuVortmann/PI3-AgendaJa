const pool = require('../../config/db');

const SELECT_BASE = `
  SELECT s.id, s.empresa_id, s.nome, s.descricao, s.duracao_minutos, s.preco, s.ativo,
         e.nome AS empresa_nome
  FROM servicos s
  INNER JOIN empresas e ON e.id = s.empresa_id
`;

async function findAllAtivos(empresaId = null) {
  const params = empresaId ? [empresaId] : [];
  const empresaWhere = empresaId ? 'AND s.empresa_id = $1' : '';
  const result = await pool.query(
    `${SELECT_BASE} WHERE s.ativo = TRUE AND e.ativo = TRUE ${empresaWhere} ORDER BY e.nome, s.nome`,
    params
  );
  return result.rows;
}

async function findAll(empresaId = null) {
  const params = empresaId ? [empresaId] : [];
  const where = empresaId ? 'WHERE s.empresa_id = $1' : '';
  const result = await pool.query(
    `${SELECT_BASE} ${where} ORDER BY s.nome`,
    params
  );
  return result.rows;
}

async function findById(id) {
  const result = await pool.query(
    `${SELECT_BASE} WHERE s.id = $1`,
    [id]
  );
  return result.rows[0];
}

async function create({ empresaId, nome, descricao, duracaoMinutos, preco }) {
  const result = await pool.query(
    `INSERT INTO servicos (empresa_id, nome, descricao, duracao_minutos, preco)
     VALUES ($1, $2, $3, $4, $5)
     RETURNING id, empresa_id, nome, descricao, duracao_minutos, preco, ativo`,
    [empresaId, nome, descricao || null, duracaoMinutos, preco]
  );
  return result.rows[0];
}

async function update(id, empresaId, { nome, descricao, duracaoMinutos, preco, ativo }) {
  const result = await pool.query(
    `UPDATE servicos
     SET nome = COALESCE($3, nome),
         descricao = COALESCE($4, descricao),
         duracao_minutos = COALESCE($5, duracao_minutos),
         preco = COALESCE($6, preco),
         ativo = COALESCE($7, ativo)
     WHERE id = $1 AND ($2::integer IS NULL OR empresa_id = $2)
     RETURNING id, empresa_id, nome, descricao, duracao_minutos, preco, ativo`,
    [id, empresaId, nome, descricao, duracaoMinutos, preco, ativo]
  );
  return result.rows[0];
}

async function remove(id, empresaId = null) {
  const result = await pool.query(
    `UPDATE servicos SET ativo = FALSE
     WHERE id = $1 AND ($2::integer IS NULL OR empresa_id = $2) RETURNING id`,
    [id, empresaId]
  );
  return result.rows[0];
}

module.exports = { findAllAtivos, findAll, findById, create, update, remove };
