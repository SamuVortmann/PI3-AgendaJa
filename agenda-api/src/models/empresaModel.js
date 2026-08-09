const pool = require('../../config/db');

const SELECT_BASE = `
  SELECT e.id, e.usuario_id, e.nome, e.cnpj, e.endereco, e.telefone,
         e.dias_funcionamento, e.hora_abertura, e.hora_fechamento,
         e.ativo, e.criado_em
  FROM empresas e
`;

async function findAllAtivas() {
  const result = await pool.query(`${SELECT_BASE} WHERE e.ativo = TRUE ORDER BY e.nome`);
  return result.rows;
}

async function findById(id) {
  const result = await pool.query(`${SELECT_BASE} WHERE e.id = $1`, [id]);
  return result.rows[0];
}

async function findByUsuarioId(usuarioId) {
  const result = await pool.query(`${SELECT_BASE} WHERE e.usuario_id = $1`, [usuarioId]);
  return result.rows[0];
}

async function create({ usuarioId, nome, cnpj, endereco, telefone, diasFuncionamento, horaAbertura, horaFechamento }) {
  const result = await pool.query(
    `INSERT INTO empresas
       (usuario_id, nome, cnpj, endereco, telefone, dias_funcionamento, hora_abertura, hora_fechamento)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
     RETURNING id, usuario_id, nome, cnpj, endereco, telefone,
               dias_funcionamento, hora_abertura, hora_fechamento, ativo, criado_em`,
    [
      usuarioId,
      nome,
      cnpj || null,
      endereco,
      telefone,
      diasFuncionamento?.length ? diasFuncionamento : [1, 2, 3, 4, 5],
      horaAbertura || '08:00',
      horaFechamento || '18:00',
    ]
  );
  return result.rows[0];
}

async function updateByUsuarioId(usuarioId, { nome, cnpj, endereco, telefone, diasFuncionamento, horaAbertura, horaFechamento, cnpjInformado = false }) {
  const result = await pool.query(
    `UPDATE empresas
     SET nome = COALESCE($2, nome),
         cnpj = CASE WHEN $9 THEN $3 ELSE cnpj END,
         endereco = COALESCE($4, endereco),
         telefone = COALESCE($5, telefone),
         dias_funcionamento = COALESCE($6, dias_funcionamento),
         hora_abertura = COALESCE($7, hora_abertura),
         hora_fechamento = COALESCE($8, hora_fechamento)
     WHERE usuario_id = $1
     RETURNING id, usuario_id, nome, cnpj, endereco, telefone,
               dias_funcionamento, hora_abertura, hora_fechamento, ativo, criado_em`,
    [usuarioId, nome, cnpj || null, endereco, telefone, diasFuncionamento, horaAbertura, horaFechamento, cnpjInformado]
  );
  return result.rows[0];
}

module.exports = { findAllAtivas, findById, findByUsuarioId, create, updateByUsuarioId };
