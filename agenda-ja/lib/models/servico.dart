import '../utils/json_utils.dart';

class Servico {
  final int id;
  final String nome;
  final String? descricao;
  final int duracaoMinutos;
  final double preco;
  final bool ativo;
  final int? empresaId;
  final String? empresaNome;

  const Servico({
    required this.id,
    required this.nome,
    this.descricao,
    required this.duracaoMinutos,
    required this.preco,
    this.ativo = true,
    this.empresaId,
    this.empresaNome,
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: parseJsonInt(json['id']),
      nome: json['nome'].toString(),
      descricao: parseJsonString(json['descricao']),
      duracaoMinutos: parseJsonInt(json['duracao_minutos']),
      preco: parseJsonDouble(json['preco']) ?? 0,
      ativo: json['ativo'] as bool? ?? true,
      empresaId: json['empresa_id'] != null
          ? parseJsonInt(json['empresa_id'])
          : null,
      empresaNome: parseJsonString(json['empresa_nome']),
    );
  }
}
