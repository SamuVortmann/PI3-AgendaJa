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

    const servicos = [
      { nome: 'Corte de cabelo', descricao: 'Corte masculino ou feminino', duracao: 45, preco: 50 },
      { nome: 'Manicure', descricao: 'Cuidados com unhas', duracao: 60, preco: 40 },
      { nome: 'Consulta psicológica', descricao: 'Sessão individual', duracao: 50, preco: 150 },
    ];

    const servicoIds = [];
    for (const s of servicos) {
      const existing = await pool.query('SELECT id FROM servicos WHERE nome = $1', [s.nome]);
      if (existing.rows[0]) {
        servicoIds.push(existing.rows[0].id);
      } else {
        const result = await pool.query(
          `INSERT INTO servicos (nome, descricao, duracao_minutos, preco)
           VALUES ($1, $2, $3, $4) RETURNING id`,
          [s.nome, s.descricao, s.duracao, s.preco]
        );
        servicoIds.push(result.rows[0].id);
      }
    }

    const profissionais = [
      { nome: 'Maria Silva', email: 'maria@agendaja.com', telefone: '49991388396', servicos: [0, 1] },
      { nome: 'João Santos', email: 'joao@agendaja.com', telefone: '49999887766', servicos: [0] },
      { nome: 'Ana Costa', email: 'ana@agendaja.com', telefone: '49988776655', servicos: [2] },
    ];

    const profIds = [];
    for (const p of profissionais) {
      let profId;
      const existing = await pool.query('SELECT id FROM profissionais WHERE email = $1', [p.email]);
      if (existing.rows[0]) {
        profId = existing.rows[0].id;
      } else {
        const result = await pool.query(
          `INSERT INTO profissionais (nome, email, telefone) VALUES ($1, $2, $3) RETURNING id`,
          [p.nome, p.email, p.telefone]
        );
        profId = result.rows[0].id;
      }
      profIds.push(profId);

      for (const idx of p.servicos) {
        const servicoId = servicoIds[idx];
        if (servicoId) {
          await pool.query(
            `INSERT INTO profissional_servico (profissional_id, servico_id)
             VALUES ($1, $2) ON CONFLICT DO NOTHING`,
            [profId, servicoId]
          );
        }
      }

      for (let dia = 1; dia <= 5; dia++) {
        const disp = await pool.query(
          `SELECT id FROM disponibilidades
           WHERE profissional_id = $1 AND dia_semana = $2 AND hora_inicio = '08:00'`,
          [profId, dia]
        );
        if (!disp.rows[0]) {
          await pool.query(
            `INSERT INTO disponibilidades (profissional_id, dia_semana, hora_inicio, hora_fim)
             VALUES ($1, $2, '08:00', '18:00')`,
            [profId, dia]
          );
        }
      }
    }

    console.log('Seed concluído.');
    console.log('Admin: admin@agendaja.com / admin123');
    console.log(`Serviços: ${servicoIds.length}, Profissionais: ${profIds.length}`);
  } catch (err) {
    console.error('Erro no seed:', err.message);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

seed();
