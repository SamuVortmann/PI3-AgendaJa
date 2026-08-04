import '../models/servico.dart';
import 'api_client.dart';

class ServicoService {
  ServicoService._();
  static final ServicoService instance = ServicoService._();

  final _api = ApiClient.instance;

  Future<List<Servico>> listarAtivos() async {
    final data = await _api.get('/servicos');
    return (data as List)
        .map((e) => Servico.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Servico>> listarAdmin() async {
    final data = await _api.get('/admin/servicos', auth: true);
    return (data as List)
        .map((e) => Servico.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Servico> criar({
    required String nome,
    String? descricao,
    required int duracaoMinutos,
    required double preco,
  }) async {
    final data = await _api.post(
      '/admin/servicos',
      auth: true,
      body: {
        'nome': nome,
        'descricao': descricao,
        'duracao_minutos': duracaoMinutos,
        'preco': preco,
      },
    );
    return Servico.fromJson(data as Map<String, dynamic>);
  }

  Future<Servico> atualizar(
    int id, {
    String? nome,
    String? descricao,
    int? duracaoMinutos,
    double? preco,
    bool? ativo,
  }) async {
    final data = await _api.put(
      '/admin/servicos/$id',
      auth: true,
      body: {
        if (nome != null) 'nome': nome,
        if (descricao != null) 'descricao': descricao,
        if (duracaoMinutos != null) 'duracao_minutos': duracaoMinutos,
        if (preco != null) 'preco': preco,
        if (ativo != null) 'ativo': ativo,
      },
    );
    return Servico.fromJson(data as Map<String, dynamic>);
  }

  Future<void> excluir(int id) async {
    await _api.delete('/admin/servicos/$id', auth: true);
  }
}
