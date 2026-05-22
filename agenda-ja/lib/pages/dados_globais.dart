class DadosGlobais {
  // Lista estática que pode ser acessada de qualquer lugar do app
  static List<Map<String, String>> empresasCadastradas = [];

  // Função para adicionar uma nova empresa
  static void adicionarEmpresa({
    required String nome,
    required String endereco,
    required String categoria,
  }) {
    empresasCadastradas.add({
      'nome': nome,
      'endereco': endereco,
      'categoria': categoria,
    });
  }
}
