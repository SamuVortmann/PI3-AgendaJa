const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../../.env') });

const obrigatorias = ['DB_USER', 'DB_HOST', 'DB_NAME', 'DB_PASSWORD', 'JWT_SECRET'];

function validarAmbiente() {
  const faltando = obrigatorias.filter((k) => !process.env[k]);
  if (faltando.length) {
    console.error('\n[ERRO] Variáveis ausentes no .env:', faltando.join(', '));
    console.error('Copie .env.example para .env na raiz do projeto e preencha os valores.\n');
    process.exit(1);
  }

  if (process.env.DB_PASSWORD === 'sua_senha') {
    console.warn('\n[AVISO] DB_PASSWORD ainda está como "sua_senha" no .env. Configure a senha real do PostgreSQL.\n');
  }
}

module.exports = { validarAmbiente };
