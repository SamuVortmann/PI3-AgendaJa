const pool = require('../../config/db');

async function findByServico(servicoId) {
  const result = await pool.query(
    `SELECT p.id, p.nome, p.email, p.telefone, p.ativo
     FROM profissionais p
     INNER JOIN profissional_servico ps ON ps.profissional_id = p.id
     WHERE ps.servico_id = $1 AND p.ativo = TRUE
     ORDER BY p.nome`,
    [servicoId]
  );
  return result.rows;
}

async function findAllAtivos() {
  const result = await pool.query(
    'SELECT id, nome, email, telefone, ativo FROM profissionais WHERE ativo = TRUE ORDER BY nome'
  );
  return result.rows;
}

async function findAll() {
  const result = await pool.query(
    'SELECT id, nome, email, telefone, ativo FROM profissionais ORDER BY nome'
  );
  return result.rows;
}

async function findById(id) {
  const result = await pool.query(
    'SELECT id, nome, email, telefone, ativo FROM profissionais WHERE id = $1',
    [id]
  );
  return result.rows[0];
}

async function findServicosByProfissional(profissionalId) {
  const result = await pool.query(
    `SELECT s.id, s.nome, s.duracao_minutos, s.preco
     FROM servicos s
     INNER JOIN profissional_servico ps ON ps.servico_id = s.id
     WHERE ps.profissional_id = $1 AND s.ativo = TRUE`,
    [profissionalId]
  );
  return result.rows;
}

async function create({ nome, email, telefone, servicoIds }) {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const profResult = await client.query(
      `INSERT INTO profissionais (nome, email, telefone)
       VALUES ($1, $2, $3)
       RETURNING id, nome, email, telefone, ativo`,
      [nome, email || null, telefone || null]
    );
    const profissional = profResult.rows[0];

    if (servicoIds?.length) {
      for (const servicoId of servicoIds) {
        await client.query(
          'INSERT INTO profissional_servico (profissional_id, servico_id) VALUES ($1, $2)',
          [profissional.id, servicoId]
        );
      }
    }

    await client.query('COMMIT');
    return profissional;
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
}

async function update(id, { nome, email, telefone, ativo, servicoIds }) {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const result = await client.query(
      `UPDATE profissionais
       SET nome = COALESCE($2, nome),
           email = COALESCE($3, email),
           telefone = COALESCE($4, telefone),
           ativo = COALESCE($5, ativo)
       WHERE id = $1
       RETURNING id, nome, email, telefone, ativo`,
      [id, nome, email, telefone, ativo]
    );

    if (!result.rows[0]) {
      await client.query('ROLLBACK');
      return null;
    }

    if (servicoIds !== undefined) {
      await client.query('DELETE FROM profissional_servico WHERE profissional_id = $1', [id]);
      for (const servicoId of servicoIds) {
        await client.query(
          'INSERT INTO profissional_servico (profissional_id, servico_id) VALUES ($1, $2)',
          [id, servicoId]
        );
      }
    }

    await client.query('COMMIT');
    return result.rows[0];
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
}

async function remove(id) {
  const result = await pool.query(
    'UPDATE profissionais SET ativo = FALSE WHERE id = $1 RETURNING id',
    [id]
  );
  return result.rows[0];
}

module.exports = {
  findByServico,
  findAllAtivos,
  findAll,
  findById,
  findServicosByProfissional,
  create,
  update,
  remove,
};
