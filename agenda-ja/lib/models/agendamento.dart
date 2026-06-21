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
      dataHoraInicio: json['data_hora_inicio'] as String,
      dataHoraFim: json['data_hora_fim'] as String,
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
      id: json['id'] as int,
      clienteId: json['cliente_id'] as int,
      profissionalId: json['profissional_id'] as int,
      servicoId: json['servico_id'] as int,
      dataHoraInicio: DateTime.parse(json['data_hora_inicio'] as String),
      dataHoraFim: DateTime.parse(json['data_hora_fim'] as String),
      status: json['status'] as String,
      clienteNome: json['cliente_nome'] as String?,
      clienteTelefone: json['cliente_telefone'] as String?,
      profissionalNome: json['profissional_nome'] as String?,
      servicoNome: json['servico_nome'] as String?,
      duracaoMinutos: json['duracao_minutos'] as int?,
      preco: json['preco'] != null ? (json['preco'] as num).toDouble() : null,
    );
  }

  bool get isCancelado => status == 'cancelado';
  bool get isFuturo =>
      !isCancelado && dataHoraInicio.isAfter(DateTime.now());
  bool get isPassado =>
      !isCancelado && dataHoraFim.isBefore(DateTime.now());
}
