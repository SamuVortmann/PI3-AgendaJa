const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/authRoutes');
const servicosRoutes = require('./routes/servicosRoutes');
const profissionaisRoutes = require('./routes/profissionaisRoutes');
const disponibilidadesRoutes = require('./routes/disponibilidadesRoutes');
const agendamentosRoutes = require('./routes/agendamentosRoutes');
const adminRoutes = require('./routes/adminRoutes');
const empresasRoutes = require('./routes/empresasRoutes');
const errorHandler = require('./middlewares/errorHandler');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', servico: 'Agenda Já API' });
});

app.use('/api/auth', authRoutes);
app.use('/api/empresas', empresasRoutes);
app.use('/api/servicos', servicosRoutes);
app.use('/api/profissionais', profissionaisRoutes);
app.use('/api/disponibilidades', disponibilidadesRoutes);
app.use('/api/agendamentos', agendamentosRoutes);
app.use('/api/admin', adminRoutes);

app.use((req, res) => {
  res.status(404).json({ erro: 'Rota não encontrada' });
});

app.use(errorHandler);

module.exports = app;
