// index.js
const express = require('express');
const cors = require('cors');
const pool = require('./config/db'); // Importa a conexão com o banco
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(express.json()); // Permite que o Express entenda JSON no corpo das requisições

// Rota de Teste do Banco de Dados
app.get('/empresas', async (req, res) => {
  try {
    const resultado = await pool.query('SELECT * FROM empresas'); // Certifique-se de criar essa tabela no Postgres
    res.json(resultado.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erro no servidor');
  }
});

// Iniciando o servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando perfeitamente na porta ${PORT}`);
});