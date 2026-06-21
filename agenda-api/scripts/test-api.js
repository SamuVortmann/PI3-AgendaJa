/**
 * Teste rápido da API Agenda Já.
 * Uso: node scripts/test-api.js
 */
const BASE = process.env.API_URL || 'http://localhost:3000';

async function request(method, path, body) {
  const res = await fetch(`${BASE}${path}`, {
    method,
    headers: body ? { 'Content-Type': 'application/json' } : undefined,
    body: body ? JSON.stringify(body) : undefined,
  });
  const text = await res.text();
  let data;
  try {
    data = text ? JSON.parse(text) : null;
  } catch {
    data = text;
  }
  return { status: res.status, data };
}

async function run() {
  console.log('=== Teste API Agenda Já ===\n');

  const health = await request('GET', '/api/health');
  console.log(`[${health.status}] GET /api/health`, health.data);
  if (health.status !== 200) process.exit(1);

  const servicos = await request('GET', '/api/servicos');
  console.log(`[${servicos.status}] GET /api/servicos`, Array.isArray(servicos.data) ? `${servicos.data.length} serviço(s)` : servicos.data);
  if (servicos.status !== 200) {
    console.error('\nFalha no banco de dados. Verifique o arquivo .env na raiz do projeto.');
    process.exit(1);
  }

  const login = await request('POST', '/api/auth/login', {
    email: 'admin@agendaja.com',
    senha: 'admin123',
  });
  console.log(`[${login.status}] POST /api/auth/login`, login.data?.usuario?.email ?? login.data);
  if (login.status !== 200) process.exit(1);

  const token = login.data.token;
  const dash = await fetch(`${BASE}/api/admin/dashboard`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  const dashData = await dash.json();
  console.log(`[${dash.status}] GET /api/admin/dashboard`, dashData);

  console.log('\nTodos os testes passaram.');
}

run().catch((err) => {
  console.error('Erro ao conectar na API:', err.message);
  console.error('Certifique-se de que o servidor está rodando: npm run dev');
  process.exit(1);
});
