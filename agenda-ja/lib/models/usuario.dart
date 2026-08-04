import '../utils/json_utils.dart';

class Usuario {
  final int id;
  final String nome;
  final String email;
  final String? telefone;
  final String perfil;
  final int? empresaId;
  final String? empresaNome;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
    required this.perfil,
    this.empresaId,
    this.empresaNome,
  });

  bool get isAdmin => perfil == 'admin';
  bool get isEmpresa => perfil == 'empresa';
  bool get isGestor => isAdmin || isEmpresa;

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: parseJsonInt(json['id']),
      nome: json['nome'].toString(),
      email: json['email'].toString(),
      telefone: parseJsonString(json['telefone']),
      perfil: json['perfil'].toString(),
      empresaId: json['empresa_id'] != null
          ? parseJsonInt(json['empresa_id'])
          : null,
      empresaNome: parseJsonString(json['empresa_nome']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'email': email,
    'telefone': telefone,
    'perfil': perfil,
    'empresa_id': empresaId,
    'empresa_nome': empresaNome,
  };
}
