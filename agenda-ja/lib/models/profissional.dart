import 'servico.dart';

class Profissional {
  final int id;
  final String nome;
  final String? email;
  final String? telefone;
  final bool ativo;
  final List<Servico> servicos;

  const Profissional({
    required this.id,
    required this.nome,
    this.email,
    this.telefone,
    this.ativo = true,
    this.servicos = const [],
  });

  factory Profissional.fromJson(Map<String, dynamic> json) {
    final servicosJson = json['servicos'] as List<dynamic>?;
    return Profissional(
      id: json['id'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String?,
      telefone: json['telefone'] as String?,
      ativo: json['ativo'] as bool? ?? true,
      servicos:
          servicosJson
              ?.map((s) => Servico.fromJson(s as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
