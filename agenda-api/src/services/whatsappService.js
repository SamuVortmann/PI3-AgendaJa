const fs = require('fs');
const path = require('path');
const pino = require('pino');
const {
  default: makeWASocket,
  useMultiFileAuthState,
  DisconnectReason,
} = require('@whiskeysockets/baileys');

const logger = pino({ level: 'silent' });
const authDir = path.join(__dirname, '../../.baileys_auth');

let sock = null;
let conectado = false;

function formatarTelefone(telefone) {
  const numeros = telefone.replace(/\D/g, '');
  if (numeros.startsWith('55')) {
    return `${numeros}@s.whatsapp.net`;
  }
  return `55${numeros}@s.whatsapp.net`;
}

function formatarDataHora(dataHora) {
  return new Date(dataHora).toLocaleString('pt-BR', {
    timeZone: process.env.APP_TIMEZONE || 'America/Sao_Paulo',
    dateStyle: 'short',
    timeStyle: 'short',
  });
}

async function iniciarWhatsApp() {
  if (process.env.WHATSAPP_ENABLED !== 'true') {
    console.log('WhatsApp desabilitado (WHATSAPP_ENABLED != true)');
    return;
  }

  if (!fs.existsSync(authDir)) {
    fs.mkdirSync(authDir, { recursive: true });
  }

  const { state, saveCreds } = await useMultiFileAuthState(authDir);

  sock = makeWASocket({
    auth: state,
    logger,
    printQRInTerminal: true,
  });

  sock.ev.on('creds.update', saveCreds);

  sock.ev.on('connection.update', (update) => {
    const { connection, lastDisconnect, qr } = update;

    if (qr) {
      console.log('Escaneie o QR Code no terminal para conectar o WhatsApp');
    }

    if (connection === 'open') {
      conectado = true;
      console.log('WhatsApp conectado com sucesso');
    }

    if (connection === 'close') {
      conectado = false;
      const statusCode = lastDisconnect?.error?.output?.statusCode;
      const deveReconectar = statusCode !== DisconnectReason.loggedOut;

      if (deveReconectar) {
        setTimeout(iniciarWhatsApp, 5000);
      }
    }
  });
}

async function enviarMensagem(telefone, mensagem) {
  if (!conectado || !sock || !telefone) {
    console.log(`[WhatsApp simulado] Para ${telefone}: ${mensagem}`);
    return false;
  }

  try {
    const jid = formatarTelefone(telefone);
    await sock.sendMessage(jid, { text: mensagem });
    return true;
  } catch (err) {
    console.error('Erro ao enviar WhatsApp:', err.message);
    return false;
  }
}

async function enviarConfirmacaoAgendamento(agendamento) {
  const mensagem =
    `✅ *Agendamento confirmado!*\n\n` +
    `Serviço: ${agendamento.servico_nome}\n` +
    `Profissional: ${agendamento.profissional_nome}\n` +
    `Data/hora: ${formatarDataHora(agendamento.data_hora_inicio)}\n\n` +
    `Agenda Já`;

  return enviarMensagem(agendamento.cliente_telefone, mensagem);
}

async function enviarNotificacaoReagendamento(agendamento) {
  const mensagem =
    `📅 *Agendamento reagendado!*\n\n` +
    `Seu agendamento recebeu uma nova data e um novo horário.\n\n` +
    `Serviço: ${agendamento.servico_nome}\n` +
    `Profissional: ${agendamento.profissional_nome}\n` +
    `Nova data e horário: ${formatarDataHora(agendamento.data_hora_inicio)}\n\n` +
    `Agenda Já`;

  return enviarMensagem(agendamento.cliente_telefone, mensagem);
}

async function enviarLembreteAgendamento(agendamento) {
  const mensagem =
    `🔔 *Lembrete de agendamento*\n\n` +
    `Seu atendimento é amanhã!\n\n` +
    `Serviço: ${agendamento.servico_nome}\n` +
    `Profissional: ${agendamento.profissional_nome}\n` +
    `Data/hora: ${formatarDataHora(agendamento.data_hora_inicio)}\n\n` +
    `Agenda Já`;

  return enviarMensagem(agendamento.cliente_telefone, mensagem);
}

module.exports = {
  iniciarWhatsApp,
  enviarMensagem,
  enviarConfirmacaoAgendamento,
  enviarNotificacaoReagendamento,
  enviarLembreteAgendamento,
};
