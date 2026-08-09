const disponibilidadeModel = require('../models/disponibilidadeModel');
const agendamentoModel = require('../models/agendamentoModel');
const servicoModel = require('../models/servicoModel');
const {
  dataHoraLocalParaUtc,
  diaDaSemana,
  validarDataIso,
} = require('../utils/dateTime');

function parseTimeToMinutes(timeStr) {
  const [hours, minutes] = timeStr.split(':').map(Number);
  return hours * 60 + minutes;
}

function minutesToTimeString(minutes) {
  const h = Math.floor(minutes / 60).toString().padStart(2, '0');
  const m = (minutes % 60).toString().padStart(2, '0');
  return `${h}:${m}`;
}

function buildDateTime(data, timeStr) {
  return dataHoraLocalParaUtc(data, timeStr.slice(0, 5));
}

async function calcularHorariosLivres(profissionalId, servicoId, data, excludeAgendamentoId = null) {
  if (!validarDataIso(data)) return [];
  const servico = await servicoModel.findById(servicoId);
  if (!servico || !servico.ativo) {
    return [];
  }

  const diaSemana = diaDaSemana(data);

  const disponibilidades = await disponibilidadeModel.findByProfissionalAndDia(
    profissionalId,
    diaSemana
  );

  if (!disponibilidades.length) {
    return [];
  }

  const agendamentos = await agendamentoModel.findAgendamentosDoDia(profissionalId, data);
  const duracao = servico.duracao_minutos;
  const horariosLivres = [];

  for (const disp of disponibilidades) {
    const inicioMin = parseTimeToMinutes(disp.hora_inicio);
    const fimMin = parseTimeToMinutes(disp.hora_fim);

    for (let slot = inicioMin; slot + duracao <= fimMin; slot += duracao) {
      const slotInicio = buildDateTime(data, minutesToTimeString(slot));
      if (!slotInicio) continue;
      const slotFim = new Date(slotInicio.getTime() + duracao * 60000);

      const conflitoAgendamento = agendamentos.some((ag) => {
        if (excludeAgendamentoId && Number(ag.id) === Number(excludeAgendamentoId)) return false;
        const agInicio = new Date(ag.data_hora_inicio);
        const agFim = new Date(ag.data_hora_fim);
        return slotInicio < agFim && slotFim > agInicio;
      });

      if (!conflitoAgendamento && slotInicio > new Date()) {
        horariosLivres.push({
          horario: minutesToTimeString(slot),
          data_hora_inicio: slotInicio.toISOString(),
          data_hora_fim: slotFim.toISOString(),
        });
      }
    }
  }

  return horariosLivres;
}

module.exports = { calcularHorariosLivres, buildDateTime };
