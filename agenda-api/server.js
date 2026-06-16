require('dotenv').config({ path: require('path').join(__dirname, '../.env') });

const app = require('./src/app');
const whatsappService = require('./src/services/whatsappService');
const reminderService = require('./src/services/reminderService');

const PORT = process.env.PORT || 3000;

if (!process.env.JWT_SECRET) {
  console.warn('AVISO: JWT_SECRET não definido. Use um valor seguro em produção.');
  process.env.JWT_SECRET = 'dev-secret-altere-em-producao';
}

app.listen(PORT, async () => {
  console.log(`Agenda Já API rodando na porta ${PORT}`);
  await whatsappService.iniciarWhatsApp();
  reminderService.iniciarLembretes();
});
