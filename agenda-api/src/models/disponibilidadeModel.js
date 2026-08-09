const pool = require('../../config/db');

async function findByProfissional(profissionalId) {
  const result = await pool.query(
    `SELECT id, profissional_id, dia_semana, hora_inicio, hora_fim
     FROM disponibilidades
     WHERE profissional_id = $1
     ORDER BY dia_semana, hora_inicio`,
    [profissionalId]
  );
  return result.rows;
}

async function findByProfissionalAndDia(profissionalId, diaSemana) {
  const result = await pool.query(
    `SELECT id, profissional_id, dia_semana, hora_inicio, hora_fim
     FROM disponibilidades
     WHERE profissional_id = $1 AND dia_semana = $2
     ORDER BY hora_inicio`,
    [profissionalId, diaSemana]
  );
  return result.rows;
}

async function findById(id) {
  const result = await pool.query(
    `SELECT d.id, d.profissional_id, d.dia_semana, d.hora_inicio, d.hora_fim,
            p.empresa_id
     FROM disponibilidades d
     INNER JOIN profissionais p ON p.id = d.profissional_id
     WHERE d.id = $1`,
    [id]
  );
  return result.rows[0];
}

async function create({ profissionalId, diaSemana, horaInicio, horaFim }) {
  const result = await pool.query(
    `INSERT INTO disponibilidades (profissional_id, dia_semana, hora_inicio, hora_fim)
     VALUES ($1, $2, $3, $4)
     RETURNING id, profissional_id, dia_semana, hora_inicio, hora_fim`,
    [profissionalId, diaSemana, horaInicio, horaFim]
  );
  return result.rows[0];
}

async function hasConflito(profissionalId, diaSemana, horaInicio, horaFim, excludeId = null) {
  const params = [profissionalId, diaSemana, horaInicio, horaFim];
  let excludeClause = '';
  if (excludeId) {
    params.push(excludeId);
    excludeClause = `AND id != $${params.length}`;
  }
  const result = await pool.query(
    `SELECT id FROM disponibilidades
     WHERE profissional_id = $1
       AND dia_semana = $2
       AND hora_inicio < $4::time
       AND hora_fim > $3::time
       ${excludeClause}
     LIMIT 1`,
    params
  );
  return result.rows.length > 0;
}

async function update(id, { diaSemana, horaInicio, horaFim }) {
  const result = await pool.query(
    `UPDATE disponibilidades
     SET dia_semana = COALESCE($2, dia_semana),
         hora_inicio = COALESCE($3, hora_inicio),
         hora_fim = COALESCE($4, hora_fim)
     WHERE id = $1
     RETURNING id, profissional_id, dia_semana, hora_inicio, hora_fim`,
    [id, diaSemana, horaInicio, horaFim]
  );
  return result.rows[0];
}

async function remove(id) {
  const result = await pool.query(
    'DELETE FROM disponibilidades WHERE id = $1 RETURNING id',
    [id]
  );
  return result.rows[0];
}

module.exports = {
  findByProfissional,
  findByProfissionalAndDia,
  findById,
  hasConflito,
  create,
  update,
  remove,
};
