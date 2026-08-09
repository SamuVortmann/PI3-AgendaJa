const APP_TIME_ZONE = process.env.APP_TIMEZONE || 'America/Sao_Paulo';

function validarDataIso(data) {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(data || '')) return false;
  const [ano, mes, dia] = data.split('-').map(Number);
  const teste = new Date(Date.UTC(ano, mes - 1, dia));
  return (
    teste.getUTCFullYear() === ano &&
    teste.getUTCMonth() === mes - 1 &&
    teste.getUTCDate() === dia
  );
}

function validarHorario(horario) {
  if (!/^\d{2}:\d{2}$/.test(horario || '')) return false;
  const [hora, minuto] = horario.split(':').map(Number);
  return hora >= 0 && hora <= 23 && minuto >= 0 && minuto <= 59;
}

function partesNoFuso(data, timeZone = APP_TIME_ZONE) {
  const partes = new Intl.DateTimeFormat('en-US', {
    timeZone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hourCycle: 'h23',
  }).formatToParts(data);
  return Object.fromEntries(partes.filter((item) => item.type !== 'literal').map((item) => [item.type, Number(item.value)]));
}

function deslocamentoDoFuso(data, timeZone = APP_TIME_ZONE) {
  const p = partesNoFuso(data, timeZone);
  const representacaoUtc = Date.UTC(p.year, p.month - 1, p.day, p.hour, p.minute, p.second);
  return representacaoUtc - data.getTime();
}

function dataHoraLocalParaUtc(data, horario, timeZone = APP_TIME_ZONE) {
  if (!validarDataIso(data) || !validarHorario(horario)) return null;
  const [ano, mes, dia] = data.split('-').map(Number);
  const [hora, minuto] = horario.split(':').map(Number);
  const baseUtc = Date.UTC(ano, mes - 1, dia, hora, minuto, 0);
  let instante = new Date(baseUtc);

  for (let tentativa = 0; tentativa < 2; tentativa += 1) {
    instante = new Date(baseUtc - deslocamentoDoFuso(instante, timeZone));
  }

  const p = partesNoFuso(instante, timeZone);
  if (p.year !== ano || p.month !== mes || p.day !== dia || p.hour !== hora || p.minute !== minuto) {
    return null;
  }
  return instante;
}

function formatarDataNoFuso(data, timeZone = APP_TIME_ZONE) {
  const p = partesNoFuso(data, timeZone);
  return `${p.year.toString().padStart(4, '0')}-${p.month.toString().padStart(2, '0')}-${p.day.toString().padStart(2, '0')}`;
}

function diaDaSemana(data) {
  if (!validarDataIso(data)) return null;
  const [ano, mes, dia] = data.split('-').map(Number);
  return new Date(Date.UTC(ano, mes - 1, dia)).getUTCDay();
}

function adicionarDias(data, quantidade) {
  if (!validarDataIso(data)) return null;
  const [ano, mes, dia] = data.split('-').map(Number);
  const resultado = new Date(Date.UTC(ano, mes - 1, dia + quantidade));
  return `${resultado.getUTCFullYear().toString().padStart(4, '0')}-${(resultado.getUTCMonth() + 1).toString().padStart(2, '0')}-${resultado.getUTCDate().toString().padStart(2, '0')}`;
}

module.exports = {
  APP_TIME_ZONE,
  adicionarDias,
  dataHoraLocalParaUtc,
  diaDaSemana,
  formatarDataNoFuso,
  validarDataIso,
  validarHorario,
};
