const bcrypt = require('bcryptjs');
const pool = require('../config/db');

async function seed() {
  const senhaHash = await bcrypt.hash('admin123', 10);

  try {
    await pool.query(
      `INSERT INTO usuarios (nome, email, senha_hash, perfil)
       VALUES ($1, $2, $3, 'admin')
       ON CONFLICT (email) DO NOTHING`,
      ['Administrador', 'admin@agendaja.com', senhaHash]
    );
    console.log('Seed concluído. Admin: admin@agendaja.com / admin123');
  } catch (err) {
    console.error('Erro no seed:', err.message);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

seed();
