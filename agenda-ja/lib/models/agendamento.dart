import '../utils/json_utils.dart';

class HorarioLivre {
  final String horario;
  final String dataHoraInicio;
  final String dataHoraFim;

  const HorarioLivre({
    required this.horario,
    required this.dataHoraInicio,
    required this.dataHoraFim,
  });

  factory HorarioLivre.fromJson(Map<String, dynamic> json) {
    return HorarioLivre(
      horario: json['horario'] as String,
      dataHoraInicio: json['data_hora_inicio'].toString(),
      dataHoraFim: json['data_hora_fim'].toString(),
    );
  }
}

class Agendamento {
  final int id;
  final int clienteId;
  final int profissionalId;
  final int servicoId;
  final DateTime dataHoraInicio;
  final DateTime dataHoraFim;
  final String status;
  final String? clienteNome;
  final String? clienteTelefone;
  final String? profissionalNome;
  final String? servicoNome;
  final int? duracaoMinutos;
  final double? preco;

  const Agendamento({
    required this.id,
    required this.clienteId,
    required this.profissionalId,
    required this.servicoId,
    required this.dataHoraInicio,
    required this.dataHoraFim,
    required this.status,
    this.clienteNome,
    this.clienteTelefone,
    this.profissionalNome,
    this.servicoNome,
    this.duracaoMinutos,
    this.preco,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      id: parseJsonInt(json['id']),
      clienteId: parseJsonInt(json['cliente_id']),
      profissionalId: parseJsonInt(json['profissional_id']),
      servicoId: parseJsonInt(json['servico_id']),
      dataHoraInicio: parseJsonDate(json['data_hora_inicio']),
      dataHoraFim: parseJsonDate(json['data_hora_fim']),
      status: json['status'].toString(),
      clienteNome: parseJsonString(json['cliente_nome']),
      clienteTelefone: parseJsonString(json['cliente_telefone']),
      profissionalNome: parseJsonString(json['profissional_nome']),
      servicoNome: parseJsonString(json['servico_nome']),
      duracaoMinutos: json['duracao_minutos'] != null
          ? parseJsonInt(json['duracao_minutos'])
          : null,
      preco: parseJsonDouble(json['preco']),
    );
  }

  bool get isCancelado => status == 'cancelado';

  bool get isFuturo {
    if (isCancelado) return false;
    return !dataHoraFim.isBefore(DateTime.now());
  }

  bool get isPassado {
    if (isCancelado) return false;
    return dataHoraFim.isBefore(DateTime.now());
  }
}
