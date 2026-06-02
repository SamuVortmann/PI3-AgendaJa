class DadosGlobais {
  // Lista de empresas cadastradas
  static List<Map<String, String>> empresasCadastradas = [];

  // Mapa de agendamentos por data (ex: '2026-05-28')
  static Map<String, List<Map<String, String>>> agendamentos = {
    '2026-05-28': [
      {
        'nome': 'Ana Beatriz da Silva',
        'horario': '09:00',
        'telefone': '(11) 98888-7777',
        'status': 'Pendente',
      },
      {
        'nome': 'Ronaldo dos Santos',
        'horario': '10:00',
        'telefone': '(11) 97777-6666',
        'status': 'Pendente',
      },
      {
        'nome': 'Felipe da Penha',
        'horario': '11:00',
        'telefone': '(11) 96666-5555',
        'status': 'Pendente',
      },
    ],
  };

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

  // Função para buscar agendamentos de uma data específica
  static List<Map<String, String>> getAgendamentosPorData(String data) {
    return agendamentos[data] ?? [];
  }
}
