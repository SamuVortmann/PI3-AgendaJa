import '../models/profissional.dart';
import 'api_client.dart';

class ProfissionalService {
  ProfissionalService._();
  static final ProfissionalService instance = ProfissionalService._();

  final _api = ApiClient.instance;

  Future<List<Profissional>> listarPorServico(int servicoId) async {
    final data =
        await _api.get('/profissionais?servico_id=$servicoId');
    return (data as List)
        .map((e) => Profissional.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Profissional>> listarAdmin() async {
    final data = await _api.get('/admin/profissionais', auth: true);
    return (data as List)
        .map((e) => Profissional.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Profissional> criar({
    required String nome,
    String? email,
    String? telefone,
    List<int>? servicoIds,
  }) async {
    final data = await _api.post('/admin/profissionais', auth: true, body: {
      'nome': nome,
      if (email != null) 'email': email,
      if (telefone != null) 'telefone': telefone,
      if (servicoIds != null) 'servico_ids': servicoIds,
    });
    return Profissional.fromJson(data as Map<String, dynamic>);
  }

  Future<Profissional> atualizar(
    int id, {
    String? nome,
    String? email,
    String? telefone,
    bool? ativo,
    List<int>? servicoIds,
  }) async {
    final data = await _api.put('/admin/profissionais/$id', auth: true, body: {
      if (nome != null) 'nome': nome,
      if (email != null) 'email': email,
      if (telefone != null) 'telefone': telefone,
      if (ativo != null) 'ativo': ativo,
      if (servicoIds != null) 'servico_ids': servicoIds,
    });
    return Profissional.fromJson(data as Map<String, dynamic>);
  }

  Future<void> excluir(int id) async {
    await _api.delete('/admin/profissionais/$id', auth: true);
  }
}
