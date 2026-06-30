import '../utils/json_utils.dart';

class Usuario {
  final int id;
  final String nome;
  final String email;
  final String? telefone;
  final String perfil;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
    required this.perfil,
  });

  bool get isAdmin => perfil == 'admin';

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: parseJsonInt(json['id']),
      nome: json['nome'].toString(),
      email: json['email'].toString(),
      telefone: parseJsonString(json['telefone']),
      perfil: json['perfil'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'perfil': perfil,
      };
}
