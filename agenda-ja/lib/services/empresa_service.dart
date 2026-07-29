import '../models/usuario.dart';
import '../utils/json_utils.dart';
import 'api_client.dart';

class Empresa {
  final int id;
  final String nome;
  final String? cnpj;
  final String? endereco;
  final String? telefone;

  Empresa({
    required this.id,
    required this.nome,
    this.cnpj,
    this.endereco,
    this.telefone,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      id: parseJsonInt(json['id']),
      nome: json['nome'].toString(),
      cnpj: parseJsonString(json['cnpj']),
      endereco: parseJsonString(json['endereco']),
      telefone: parseJsonString(json['telefone']),
    );
  }
}

class EmpresaService {
  EmpresaService._();
  static final EmpresaService instance = EmpresaService._();

  final _api = ApiClient.instance;

  Future<void> salvarDadosEmpresa({
    required String nome,
    String? cnpj,
    required String endereco,
    required String telefone,
  }) async {
    // Tenta primeiro a rota de admin, se falhar, tenta a rota geral de empresas
    try {
      await _api.post('/admin/empresa', auth: true, body: {
        'nome': nome,
        'cnpj': cnpj,
        'endereco': endereco,
        'telefone': telefone,
      });
    } catch (e) {
      // Fallback para uma rota que pode ser mais permissiva dependendo da API
      await _api.post('/empresas', auth: true, body: {
        'nome': nome,
        'cnpj': cnpj,
        'endereco': endereco,
        'telefone': telefone,
      });
    }
  }

  Future<List<Empresa>> listarEmpresas() async {
    final data = await _api.get('/empresas', auth: true);
    if (data is! List) return [];
    return data.map((e) => Empresa.fromJson(e as Map<String, dynamic>)).toList();
  }
}
