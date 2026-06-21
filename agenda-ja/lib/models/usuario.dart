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
      id: json['id'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
      telefone: json['telefone'] as String?,
      perfil: json['perfil'] as String,
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
