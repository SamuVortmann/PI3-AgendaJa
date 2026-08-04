import '../models/agendamento.dart';
import 'api_client.dart';

class DisponibilidadeSlot {
  final int id;
  final int profissionalId;
  final int diaSemana;
  final String horaInicio;
  final String horaFim;

  DisponibilidadeSlot({
    required this.id,
    required this.profissionalId,
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFim,
  });

  factory DisponibilidadeSlot.fromJson(Map<String, dynamic> json) {
    return DisponibilidadeSlot(
      id: json['id'] as int,
      profissionalId: json['profissional_id'] as int,
      diaSemana: json['dia_semana'] as int,
      horaInicio: json['hora_inicio'] as String,
      horaFim: json['hora_fim'] as String,
    );
  }
}

class DisponibilidadeService {
  DisponibilidadeService._();
  static final DisponibilidadeService instance = DisponibilidadeService._();

  final _api = ApiClient.instance;

  Future<List<HorarioLivre>> horariosLivres({
    required int profissionalId,
    required int servicoId,
    required String data,
  }) async {
    final dataResp = await _api.get(
      '/disponibilidades?profissional_id=$profissionalId&servico_id=$servicoId&data=$data',
    );
    final horarios = dataResp['horarios'] as List;
    return horarios
        .map((e) => HorarioLivre.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<DisponibilidadeSlot>> listarAdmin(int profissionalId) async {
    final data = await _api.get(
      '/admin/disponibilidades?profissional_id=$profissionalId',
      auth: true,
    );
    return (data as List)
        .map((e) => DisponibilidadeSlot.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DisponibilidadeSlot> criar({
    required int profissionalId,
    required int diaSemana,
    required String horaInicio,
    required String horaFim,
  }) async {
    final data = await _api.post(
      '/admin/disponibilidades',
      auth: true,
      body: {
        'profissional_id': profissionalId,
        'dia_semana': diaSemana,
        'hora_inicio': horaInicio,
        'hora_fim': horaFim,
      },
    );
    return DisponibilidadeSlot.fromJson(data as Map<String, dynamic>);
  }

  Future<void> excluir(int id) async {
    await _api.delete('/admin/disponibilidades/$id', auth: true);
  }
}
