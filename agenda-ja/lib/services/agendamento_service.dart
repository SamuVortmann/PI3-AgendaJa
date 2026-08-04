import '../models/agendamento.dart';
import '../utils/json_utils.dart';
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
      hoje: parseJsonInt(json['agendamentos_hoje']),
      semana: parseJsonInt(json['agendamentos_semana']),
      mes: parseJsonInt(json['agendamentos_mes']),
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
    final data = await _api.post(
      '/agendamentos',
      auth: true,
      body: {
        'profissional_id': profissionalId,
        'servico_id': servicoId,
        'data_hora_inicio': dataHoraInicio,
      },
    );
    return Agendamento.fromJson(data as Map<String, dynamic>);
  }

  Future<List<Agendamento>> meusAgendamentos() async {
    final data = await _api.get('/agendamentos/meus', auth: true);
    if (data is! List) return [];
    return data
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
    String? dataInicio,
    String? dataFim,
  }) async {
    final params = <String>[];
    if (visao != null) params.add('visao=$visao');
    if (status != null) params.add('status=$status');
    if (dataInicio != null) params.add('data_inicio=$dataInicio');
    if (dataFim != null) params.add('data_fim=$dataFim');
    final query = params.isEmpty ? '' : '?${params.join('&')}';
    final data = await _api.get('/admin/agendamentos$query', auth: true);
    if (data is! List) return [];
    return data
        .map((e) => Agendamento.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Agendamento> atualizarAdmin(
    int id, {
    String? status,
    String? dataHoraInicio,
  }) async {
    final data = await _api.put(
      '/admin/agendamentos/$id',
      auth: true,
      body: {
        if (status != null) 'status': status,
        if (dataHoraInicio != null) 'data_hora_inicio': dataHoraInicio,
      },
    );
    return Agendamento.fromJson(data as Map<String, dynamic>);
  }

  Future<DashboardTotais> dashboard() async {
    final data = await _api.get('/admin/dashboard', auth: true);
    return DashboardTotais.fromJson(data as Map<String, dynamic>);
  }
}
