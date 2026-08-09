// config/db.js
const path = require('path');
const { Pool } = require('pg');
require('dotenv').config({ path: path.join(__dirname, '../../.env') });

const appTimeZone = process.env.APP_TIMEZONE || 'America/Sao_Paulo';

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
  options: `-c timezone=${appTimeZone}`,
});

module.exports = pool;
