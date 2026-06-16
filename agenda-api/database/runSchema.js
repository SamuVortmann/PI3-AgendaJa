const fs = require('fs');
const path = require('path');
const pool = require('../config/db');

async function runSchema() {
  const schemaPath = path.join(__dirname, 'schema.sql');
  const sql = fs.readFileSync(schemaPath, 'utf8');

  try {
    await pool.query(sql);
    console.log('Schema aplicado com sucesso.');
  } catch (err) {
    console.error('Erro ao aplicar schema:', err.message);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

runSchema();
