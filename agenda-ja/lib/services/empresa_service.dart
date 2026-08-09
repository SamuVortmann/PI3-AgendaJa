import '../utils/json_utils.dart';
import 'api_client.dart';

class Empresa {
  final int id;
  final String nome;
  final String? cnpj;
  final String? endereco;
  final String? telefone;
  final List<int> diasFuncionamento;
  final String? horaAbertura;
  final String? horaFechamento;

  Empresa({
    required this.id,
    required this.nome,
    this.cnpj,
    this.endereco,
    this.telefone,
    this.diasFuncionamento = const [],
    this.horaAbertura,
    this.horaFechamento,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      id: parseJsonInt(json['id']),
      nome: json['nome'].toString(),
      cnpj: parseJsonString(json['cnpj']),
      endereco: parseJsonString(json['endereco']),
      telefone: parseJsonString(json['telefone']),
      diasFuncionamento:
          (json['dias_funcionamento'] as List<dynamic>?)
              ?.map((dia) => parseJsonInt(dia))
              .toList() ??
          const [],
      horaAbertura: parseJsonString(json['hora_abertura']),
      horaFechamento: parseJsonString(json['hora_fechamento']),
    );
  }
}

class EmpresaService {
  EmpresaService._();
  static final EmpresaService instance = EmpresaService._();

  final _api = ApiClient.instance;

  Future<Empresa> salvarDadosEmpresa({
    required String nome,
    String? cnpj,
    required String endereco,
    required String telefone,
    required List<int> diasFuncionamento,
    required String horaAbertura,
    required String horaFechamento,
  }) async {
    final data = await _api.post(
      '/empresas',
      auth: true,
      body: {
        'nome': nome,
        if (cnpj != null && cnpj.isNotEmpty) 'cnpj': cnpj,
        'endereco': endereco,
        'telefone': telefone,
        'dias_funcionamento': diasFuncionamento,
        'hora_abertura': horaAbertura,
        'hora_fechamento': horaFechamento,
      },
    );
    return Empresa.fromJson(data as Map<String, dynamic>);
  }

  Future<List<Empresa>> listarEmpresas() async {
    final data = await _api.get('/empresas');
    if (data is! List) return [];
    return data
        .map((e) => Empresa.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Empresa> minhaEmpresa() async {
    final data = await _api.get('/empresas/minha', auth: true);
    return Empresa.fromJson(data as Map<String, dynamic>);
  }

  Future<Empresa> atualizarMinhaEmpresa({
    required String nome,
    String? cnpj,
    required String endereco,
    required String telefone,
    required List<int> diasFuncionamento,
    required String horaAbertura,
    required String horaFechamento,
  }) async {
    final data = await _api.put(
      '/empresas/minha',
      auth: true,
      body: {
        'nome': nome,
        'cnpj': cnpj,
        'endereco': endereco,
        'telefone': telefone,
        'dias_funcionamento': diasFuncionamento,
        'hora_abertura': horaAbertura,
        'hora_fechamento': horaFechamento,
      },
    );
    return Empresa.fromJson(data as Map<String, dynamic>);
  }
}
