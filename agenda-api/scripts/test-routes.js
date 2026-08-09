require('dotenv').config({ path: require('path').join(__dirname, '../../.env') });

const app = require('../src/app');
const pool = require('../config/db');
const {
  dataHoraLocalParaUtc,
  diaDaSemana,
  formatarDataNoFuso,
} = require('../src/utils/dateTime');

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

  async function requestErro(method, path, statusEsperado, { token, body } = {}) {
    const response = await fetch(`${base}${path}`, {
      method,
      headers: {
        ...(body ? { 'Content-Type': 'application/json' } : {}),
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
      body: body ? JSON.stringify(body) : undefined,
    });
    assert(response.status === statusEsperado, `${method} ${path}: esperado ${statusEsperado}, recebido ${response.status}`);
    return response.json();
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

    const empresaAtualizada = await request('PUT', '/empresas/minha', {
      token: contaEmpresa.token,
      body: {
        nome: 'Empresa de Teste Atualizada',
        cnpj: null,
        endereco: 'Rua de Teste, 2',
        telefone: '49888888888',
        dias_funcionamento: [1, 2, 3, 4, 5, 6],
        hora_abertura: '08:30',
        hora_fechamento: '18:30',
      },
    });
    assert(empresaAtualizada.nome === 'Empresa de Teste Atualizada', 'Edicao da empresa falhou');
    assert(empresaAtualizada.hora_abertura.startsWith('08:30'), 'Edicao do horario da empresa falhou');

    const servico = await request('POST', '/admin/servicos', {
      token: contaEmpresa.token,
      body: { nome: 'Servico Teste', duracao_minutos: 30, preco: 10 },
    });
    const servicoAtualizado = await request('PUT', `/admin/servicos/${servico.id}`, {
      token: contaEmpresa.token,
      body: { nome: 'Servico Teste Editado', descricao: 'Descricao editada', duracao_minutos: 30, preco: 12.5 },
    });
    assert(servicoAtualizado.nome === 'Servico Teste Editado', 'Edicao do servico falhou');
    await request('PUT', `/admin/servicos/${servico.id}`, {
      token: contaEmpresa.token,
      body: { ativo: false },
    });
    const servicoReativado = await request('PUT', `/admin/servicos/${servico.id}`, {
      token: contaEmpresa.token,
      body: { ativo: true },
    });
    assert(servicoReativado.ativo === true, 'Ativacao do servico falhou');
    const profissional = await request('POST', '/admin/profissionais', {
      token: contaEmpresa.token,
      body: { nome: 'Profissional Teste', servico_ids: [servico.id] },
    });
    const profissionalAtualizado = await request('PUT', `/admin/profissionais/${profissional.id}`, {
      token: contaEmpresa.token,
      body: {
        nome: 'Profissional Teste Editado',
        email: 'profissional@example.com',
        telefone: '49777777777',
        servico_ids: [servico.id],
      },
    });
    assert(profissionalAtualizado.nome === 'Profissional Teste Editado', 'Edicao do profissional falhou');
    await request('PUT', `/admin/profissionais/${profissional.id}`, {
      token: contaEmpresa.token,
      body: { ativo: false },
    });
    const profissionalReativado = await request('PUT', `/admin/profissionais/${profissional.id}`, {
      token: contaEmpresa.token,
      body: { ativo: true },
    });
    assert(profissionalReativado.ativo === true, 'Ativacao do profissional falhou');

    const data = new Date();
    data.setDate(data.getDate() + 7);
    const dataIso = formatarDataNoFuso(data);
    const disponibilidade = await request('POST', '/admin/disponibilidades', {
      token: contaEmpresa.token,
      body: {
        profissional_id: profissional.id,
        dia_semana: diaDaSemana(dataIso),
        hora_inicio: '09:00',
        hora_fim: '10:00',
      },
    });
    const disponibilidadeAtualizada = await request('PUT', `/admin/disponibilidades/${disponibilidade.id}`, {
      token: contaEmpresa.token,
      body: { dia_semana: diaDaSemana(dataIso), hora_inicio: '09:00', hora_fim: '10:30' },
    });
    assert(disponibilidadeAtualizada.hora_fim.startsWith('10:30'), 'Edicao da disponibilidade falhou');
    await requestErro('POST', '/admin/disponibilidades', 409, {
      token: contaEmpresa.token,
      body: {
        profissional_id: profissional.id,
        dia_semana: diaDaSemana(dataIso),
        hora_inicio: '10:00',
        hora_fim: '11:00',
      },
    });
    const disponibilidadeTemporaria = await request('POST', '/admin/disponibilidades', {
      token: contaEmpresa.token,
      body: {
        profissional_id: profissional.id,
        dia_semana: (diaDaSemana(dataIso) + 1) % 7,
        hora_inicio: '14:00',
        hora_fim: '15:00',
      },
    });
    await request('DELETE', `/admin/disponibilidades/${disponibilidadeTemporaria.id}`, {
      token: contaEmpresa.token,
    });

    const contaCliente = await request('POST', '/auth/register', {
      body: { nome: 'Cliente Teste', email: clienteEmail, senha: 'teste123', perfil: 'cliente' },
    });
    const perfilCliente = await request('PUT', '/auth/me', {
      token: contaCliente.token,
      body: { nome: 'Cliente Teste Editado', telefone: '49666666666' },
    });
    assert(perfilCliente.usuario.nome === 'Cliente Teste Editado', 'Edicao do perfil do cliente falhou');
    await requestErro(
      'GET',
      `/disponibilidades?profissional_id=${profissional.id}&servico_id=${servico.id}&data=2026-02-31`,
      400
    );
    const horarios = await request(
      'GET',
      `/disponibilidades?profissional_id=${profissional.id}&servico_id=${servico.id}&data=${dataIso}`
    );
    assert(horarios.horarios.length > 0, 'Rota de disponibilidade nao retornou horarios');
    const noveHoras = dataHoraLocalParaUtc(dataIso, '09:00');
    assert(noveHoras && horarios.horarios[0].data_hora_inicio === noveHoras.toISOString(), 'Conversao de fuso do horario falhou');
    const foraDaDisponibilidade = dataHoraLocalParaUtc(dataIso, '08:00');
    await requestErro('POST', '/agendamentos', 409, {
      token: contaCliente.token,
      body: {
        profissional_id: profissional.id,
        servico_id: servico.id,
        data_hora_inicio: foraDaDisponibilidade.toISOString(),
      },
    });

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

    const confirmado = await request('PUT', `/admin/agendamentos/${agendamento.id}`, {
      token: contaEmpresa.token,
      body: { status: 'confirmado' },
    });
    assert(confirmado.status === 'confirmado', 'Alteracao de status falhou');
    const reagendado = await request('PUT', `/admin/agendamentos/${agendamento.id}`, {
      token: contaEmpresa.token,
      body: { data_hora_inicio: horarios.horarios[1].data_hora_inicio },
    });
    assert(
      new Date(reagendado.data_hora_inicio).getTime() === new Date(horarios.horarios[1].data_hora_inicio).getTime(),
      'Reagendamento falhou'
    );
    assert(reagendado.reagendado_em, 'O reagendamento não registrou a notificação');
    const meusAposReagendamento = await request('GET', '/agendamentos/meus', {
      token: contaCliente.token,
    });
    assert(
      meusAposReagendamento.some(
        (item) => item.id === agendamento.id && item.reagendado_em
      ),
      'A notificação de reagendamento não apareceu para o cliente'
    );
    const agenda = await request('GET', '/admin/agendamentos?visao=todos', { token: contaEmpresa.token });
    assert(agenda.some((item) => item.id === agendamento.id), 'Agendamento nao apareceu para a empresa');
    assert(
      agenda.some((item) => item.id === agendamento.id && item.reagendado_em),
      'A notificação de reagendamento não apareceu para a empresa'
    );
    const agendaDaData = await request(
      'GET',
      `/admin/agendamentos?data_inicio=${dataIso}&data_fim=${dataIso}`,
      { token: contaEmpresa.token }
    );
    assert(agendaDaData.some((item) => item.id === agendamento.id), 'Data do agendamento nao apareceu para a empresa');
    const agendaDaSemanaAtual = await request('GET', '/admin/agendamentos?visao=semana', {
      token: contaEmpresa.token,
    });
    assert(
      !agendaDaSemanaAtual.some((item) => item.id === agendamento.id),
      'A visao semanal misturou um agendamento da semana seguinte'
    );

    const canceladoPelaEmpresa = await request('PUT', `/admin/agendamentos/${agendamento.id}`, {
      token: contaEmpresa.token,
      body: { status: 'cancelado' },
    });
    assert(canceladoPelaEmpresa.status === 'cancelado', 'Cancelamento pela empresa falhou');

    const agendamentoDoCliente = await request('POST', '/agendamentos', {
      token: contaCliente.token,
      body: {
        profissional_id: profissional.id,
        servico_id: servico.id,
        data_hora_inicio: horarios.horarios[2].data_hora_inicio,
      },
    });
    const canceladoPeloCliente = await request('DELETE', `/agendamentos/${agendamentoDoCliente.id}`, {
      token: contaCliente.token,
    });
    assert(canceladoPeloCliente.status === 'cancelado', 'Cancelamento pelo cliente falhou');

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
