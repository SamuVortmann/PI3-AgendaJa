require('dotenv').config({ path: require('path').join(__dirname, '../../.env') });

const app = require('../src/app');
const pool = require('../config/db');

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

async function run() {
  const suffix = `${Date.now()}-${Math.floor(Math.random() * 10000)}`;
  const empresaEmail = `teste-empresa-${suffix}@example.com`;
  const clienteEmail = `teste-cliente-${suffix}@example.com`;
  const server = app.listen(0);
  await new Promise((resolve) => server.once('listening', resolve));
  const base = `http://127.0.0.1:${server.address().port}/api`;

  async function request(method, path, { token, body } = {}) {
    const response = await fetch(`${base}${path}`, {
      method,
      headers: {
        ...(body ? { 'Content-Type': 'application/json' } : {}),
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
      body: body ? JSON.stringify(body) : undefined,
    });
    const data = await response.json();
    if (!response.ok) throw new Error(`${method} ${path}: ${response.status} ${data.erro || ''}`);
    return data;
  }

  try {
    const contaEmpresa = await request('POST', '/auth/register', {
      body: { nome: 'Gestor Teste', email: empresaEmail, senha: 'teste123', perfil: 'empresa' },
    });
    assert(contaEmpresa.usuario.perfil === 'empresa', 'Perfil da conta de empresa incorreto');

    const empresa = await request('POST', '/empresas', {
      token: contaEmpresa.token,
      body: {
        nome: 'Empresa de Teste',
        endereco: 'Rua de Teste, 1',
        telefone: '49999999999',
        dias_funcionamento: [0, 1, 2, 3, 4, 5, 6],
        hora_abertura: '08:00',
        hora_fechamento: '18:00',
      },
    });

    const gestor = await request('GET', '/auth/me', { token: contaEmpresa.token });
    assert(Number(gestor.usuario.empresa_id) === Number(empresa.id), 'Sessao nao recebeu empresa_id');

    const servico = await request('POST', '/admin/servicos', {
      token: contaEmpresa.token,
      body: { nome: 'Servico Teste', duracao_minutos: 30, preco: 10 },
    });
    const profissional = await request('POST', '/admin/profissionais', {
      token: contaEmpresa.token,
      body: { nome: 'Profissional Teste', servico_ids: [servico.id] },
    });

    const data = new Date();
    data.setDate(data.getDate() + 7);
    const dataIso = data.toISOString().slice(0, 10);
    await request('POST', '/admin/disponibilidades', {
      token: contaEmpresa.token,
      body: {
        profissional_id: profissional.id,
        dia_semana: data.getDay(),
        hora_inicio: '09:00',
        hora_fim: '10:00',
      },
    });

    const contaCliente = await request('POST', '/auth/register', {
      body: { nome: 'Cliente Teste', email: clienteEmail, senha: 'teste123', perfil: 'cliente' },
    });
    const horarios = await request(
      'GET',
      `/disponibilidades?profissional_id=${profissional.id}&servico_id=${servico.id}&data=${dataIso}`
    );
    assert(horarios.horarios.length > 0, 'Rota de disponibilidade nao retornou horarios');

    const agendamento = await request('POST', '/agendamentos', {
      token: contaCliente.token,
      body: {
        profissional_id: profissional.id,
        servico_id: servico.id,
        data_hora_inicio: horarios.horarios[0].data_hora_inicio,
      },
    });
    const meus = await request('GET', '/agendamentos/meus', { token: contaCliente.token });
    assert(meus.some((item) => item.id === agendamento.id), 'Agendamento nao apareceu para o cliente');

    const agenda = await request('GET', '/admin/agendamentos?visao=todos', { token: contaEmpresa.token });
    assert(agenda.some((item) => item.id === agendamento.id), 'Agendamento nao apareceu para a empresa');
    await request('DELETE', `/agendamentos/${agendamento.id}`, { token: contaCliente.token });

    console.log('Fluxos de empresa, cliente e agendamento validados com sucesso.');
  } finally {
    await pool.query(
      `DELETE FROM agendamentos
       WHERE cliente_id IN (SELECT id FROM usuarios WHERE email = ANY($1::text[]))
          OR empresa_id IN (
            SELECT e.id FROM empresas e INNER JOIN usuarios u ON u.id = e.usuario_id
            WHERE u.email = ANY($1::text[])
          )`,
      [[empresaEmail, clienteEmail]]
    );
    await pool.query('DELETE FROM usuarios WHERE email = ANY($1::text[])', [[empresaEmail, clienteEmail]]);
    await pool.end();
    await new Promise((resolve) => server.close(resolve));
  }
}

run().catch((err) => {
  console.error(err.message);
  process.exitCode = 1;
});
