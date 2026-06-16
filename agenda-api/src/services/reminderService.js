const cron = require('node-cron');
const agendamentoModel = require('../models/agendamentoModel');
const whatsappService = require('./whatsappService');

function iniciarLembretes() {
  cron.schedule('0 * * * *', async () => {
    try {
      const pendentes = await agendamentoModel.findPendentesLembrete();

      for (const agendamento of pendentes) {
        const enviado = await whatsappService.enviarLembreteAgendamento(agendamento);
        if (enviado || process.env.WHATSAPP_ENABLED !== 'true') {
          await agendamentoModel.marcarLembreteEnviado(agendamento.id);
        }
      }
    } catch (err) {
      console.error('Erro no job de lembretes:', err.message);
    }
  });

  console.log('Job de lembretes WhatsApp agendado (a cada hora)');
}

module.exports = { iniciarLembretes };
