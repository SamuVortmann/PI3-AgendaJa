import '../models/agendamento.dart';
import 'api_client.dart';

class DashboardTotais {
  final int hoje;
  final int semana;
  final int mes;

  DashboardTotais({
    required this.hoje,
    required this.semana,
    required this.mes,
  });

  factory DashboardTotais.fromJson(Map<String, dynamic> json) {
    return DashboardTotais(
      hoje: json['agendamentos_hoje'] as int,
      semana: json['agendamentos_semana'] as int,
      mes: json['agendamentos_mes'] as int,
    );
  }
}

class AgendamentoService {
  AgendamentoService._();
  static final AgendamentoService instance = AgendamentoService._();

  final _api = ApiClient.instance;

  Future<Agendamento> criar({
    required int profissionalId,
    required int servicoId,
    required String dataHoraInicio,
  }) async {
    final data = await _api.post('/agendamentos', auth: true, body: {
      'profissional_id': profissionalId,
      'servico_id': servicoId,
      'data_hora_inicio': dataHoraInicio,
    });
    return Agendamento.fromJson(data as Map<String, dynamic>);
  }

  Future<List<Agendamento>> meusAgendamentos() async {
    final data = await _api.get('/agendamentos/meus', auth: true);
    return (data as List)
        .map((e) => Agendamento.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Agendamento> cancelar(int id) async {
    final data = await _api.delete('/agendamentos/$id', auth: true);
    return Agendamento.fromJson(data as Map<String, dynamic>);
  }

  Future<List<Agendamento>> listarAdmin({
    String? visao,
    String? status,
  }) async {
    var path = '/admin/agendamentos?';
    if (visao != null) path += 'visao=$visao&';
    if (status != null) path += 'status=$status&';
    final data = await _api.get(path, auth: true);
    return (data as List)
        .map((e) => Agendamento.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Agendamento> atualizarAdmin(
    int id, {
    String? status,
    String? dataHoraInicio,
  }) async {
    final data = await _api.put('/admin/agendamentos/$id', auth: true, body: {
      if (status != null) 'status': status,
      if (dataHoraInicio != null) 'data_hora_inicio': dataHoraInicio,
    });
    return Agendamento.fromJson(data as Map<String, dynamic>);
  }

  Future<DashboardTotais> dashboard() async {
    final data = await _api.get('/admin/dashboard', auth: true);
    return DashboardTotais.fromJson(data as Map<String, dynamic>);
  }
}
