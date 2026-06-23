class Servico {
  final int id;
  final String nome;
  final String? descricao;
  final int duracaoMinutos;
  final double preco;
  final bool ativo;

  const Servico({
    required this.id,
    required this.nome,
    this.descricao,
    required this.duracaoMinutos,
    required this.preco,
    this.ativo = true,
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String?,
      duracaoMinutos: json['duracao_minutos'] as int,
      preco: double.parse(json['preco'].toString()),
      ativo: json['ativo'] as bool? ?? true,
    );
  }
}
