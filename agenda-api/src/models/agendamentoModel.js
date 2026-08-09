const pool = require('../../config/db');

const SELECT_BASE = `
  SELECT a.id, a.empresa_id, a.cliente_id, a.profissional_id, a.servico_id,
         a.data_hora_inicio, a.data_hora_fim, a.status, a.lembrete_enviado,
         a.reagendado_em, a.criado_em,
         u.nome AS cliente_nome, u.email AS cliente_email, u.telefone AS cliente_telefone,
         p.nome AS profissional_nome, s.nome AS servico_nome, s.duracao_minutos, s.preco,
         e.nome AS empresa_nome, e.endereco AS empresa_endereco
  FROM agendamentos a
  INNER JOIN usuarios u ON u.id = a.cliente_id
  INNER JOIN profissionais p ON p.id = a.profissional_id
  INNER JOIN servicos s ON s.id = a.servico_id
  INNER JOIN empresas e ON e.id = a.empresa_id
`;

async function findById(id) {
  const result = await pool.query(`${SELECT_BASE} WHERE a.id = $1`, [id]);
  return result.rows[0];
}

async function findByCliente(clienteId) {
  const result = await pool.query(
    `${SELECT_BASE} WHERE a.cliente_id = $1 ORDER BY a.data_hora_inicio DESC`,
    [clienteId]
  );
  return result.rows;
}

async function findAll({ dataInicio, dataFim, status, empresaId } = {}) {
  const conditions = [];
  const params = [];

  if (dataInicio) {
    params.push(dataInicio);
    conditions.push(`a.data_hora_inicio::date >= $${params.length}::date`);
  }
  if (dataFim) {
    params.push(dataFim);
    conditions.push(`a.data_hora_inicio::date <= $${params.length}::date`);
  }
  if (status) {
    params.push(status);
    conditions.push(`a.status = $${params.length}`);
  }
  if (empresaId) {
    params.push(empresaId);
    conditions.push(`a.empresa_id = $${params.length}`);
  }

  const where = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';
  const result = await pool.query(
    `${SELECT_BASE} ${where} ORDER BY a.data_hora_inicio ASC`,
    params
  );
  return result.rows;
}

async function hasConflito(profissionalId, inicio, fim, excludeId = null) {
  const params = [profissionalId, inicio, fim];
  let excludeClause = '';

  if (excludeId) {
    params.push(excludeId);
    excludeClause = `AND a.id != $${params.length}`;
  }

  const result = await pool.query(
    `SELECT id FROM agendamentos a
     WHERE a.profissional_id = $1
       AND a.status != 'cancelado'
       AND (a.data_hora_inicio, a.data_hora_fim) OVERLAPS ($2::timestamptz, $3::timestamptz)
       ${excludeClause}
     LIMIT 1`,
    params
  );
  return result.rows.length > 0;
}

async function create({ empresaId, clienteId, profissionalId, servicoId, dataHoraInicio, dataHoraFim }) {
  const result = await pool.query(
    `INSERT INTO agendamentos (empresa_id, cliente_id, profissional_id, servico_id, data_hora_inicio, data_hora_fim)
     VALUES ($1, $2, $3, $4, $5, $6)
     RETURNING id, empresa_id, cliente_id, profissional_id, servico_id, data_hora_inicio, data_hora_fim, status, criado_em`,
    [empresaId, clienteId, profissionalId, servicoId, dataHoraInicio, dataHoraFim]
  );
  return result.rows[0];
}

async function updateStatus(id, status) {
  const result = await pool.query(
    `UPDATE agendamentos SET status = $2 WHERE id = $1
     RETURNING id, cliente_id, profissional_id, servico_id, data_hora_inicio, data_hora_fim, status`,
    [id, status]
  );
  return result.rows[0];
}

async function reagendar(id, { dataHoraInicio, dataHoraFim }) {
  const result = await pool.query(
    `UPDATE agendamentos
     SET data_hora_inicio = $2,
         data_hora_fim = $3,
         status = 'pendente',
         lembrete_enviado = FALSE,
         reagendado_em = CURRENT_TIMESTAMP
     WHERE id = $1
     RETURNING id, cliente_id, profissional_id, servico_id, data_hora_inicio,
               data_hora_fim, status, reagendado_em`,
    [id, dataHoraInicio, dataHoraFim]
  );
  return result.rows[0];
}

async function findAgendamentosDoDia(profissionalId, data) {
  const result = await pool.query(
    `SELECT id, data_hora_inicio, data_hora_fim
     FROM agendamentos
     WHERE profissional_id = $1
       AND status != 'cancelado'
       AND data_hora_inicio::date = $2::date`,
    [profissionalId, data]
  );
  return result.rows;
}

async function findPendentesLembrete() {
  const result = await pool.query(
    `${SELECT_BASE}
     WHERE a.lembrete_enviado = FALSE
       AND a.status IN ('pendente', 'confirmado')
       AND a.data_hora_inicio BETWEEN NOW() + INTERVAL '23 hours' AND NOW() + INTERVAL '25 hours'`
  );
  return result.rows;
}

async function marcarLembreteEnviado(id) {
  await pool.query('UPDATE agendamentos SET lembrete_enviado = TRUE WHERE id = $1', [id]);
}

async function contarPorPeriodo(empresaId = null) {
  const result = await pool.query(
    `SELECT
       COUNT(*) FILTER (WHERE data_hora_inicio::date = CURRENT_DATE AND status != 'cancelado') AS hoje,
       COUNT(*) FILTER (
         WHERE data_hora_inicio >= date_trunc('week', CURRENT_DATE)
           AND data_hora_inicio < date_trunc('week', CURRENT_DATE) + INTERVAL '7 days'
           AND status != 'cancelado'
       ) AS semana,
       COUNT(*) FILTER (
         WHERE data_hora_inicio >= date_trunc('month', CURRENT_DATE)
           AND data_hora_inicio < date_trunc('month', CURRENT_DATE) + INTERVAL '1 month'
           AND status != 'cancelado'
       ) AS mes
     FROM agendamentos
     WHERE ($1::integer IS NULL OR empresa_id = $1)`,
    [empresaId]
  );
  return result.rows[0];
}

module.exports = {
  findById,
  findByCliente,
  findAll,
  hasConflito,
  create,
  updateStatus,
  reagendar,
  findAgendamentosDoDia,
  findPendentesLembrete,
  marcarLembreteEnviado,
  contarPorPeriodo,
};
