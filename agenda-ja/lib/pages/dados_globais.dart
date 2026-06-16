class DadosGlobais {
  // 1. Lista de empresas cadastradas (Para a tela de Agendar)
  static List<Map<String, String>> empresasCadastradas = [];

  // 2. Mapa de agendamentos por data (Para a visão da Empresa)
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

  // 3. Lista de Meus Agendamentos (Para a visão do Cliente)
  // Adicionamos um ID para facilitar o cancelamento
  static List<Map<String, dynamic>> meusAgendamentosCliente = [
    {
      'id': '1',
      'data': '10/06/2026',
      'local': 'Clinica Tesser - Concórdia',
      'horario': '16:50',
      'status': 'Futuro'
    },
    {
      'id': '2',
      'data': '25/07/2026',
      'local': 'Hospital São Francisco',
      'horario': '08:10',
      'status': 'Futuro'
    },
    {
      'id': '3',
      'data': '28/05/2026',
      'local': 'Clinica vida - Concórdia',
      'horario': '15:30',
      'status': 'Passado'
    },
    {
      'id': '4',
      'data': '28/05/2026',
      'local': 'Salão Bela Vista - Irani',
      'horario': '18:00',
      'status': 'Cancelado'
    },
  ];

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

  // Função para buscar agendamentos de uma data específica (Visão Empresa)
  static List<Map<String, String>> getAgendamentosPorData(String data) {
    return agendamentos[data] ?? [];
  }

  // Função para cancelar um agendamento (Visão Cliente)
  static void cancelarAgendamento(String id) {
    int index = meusAgendamentosCliente.indexWhere((ag) => ag['id'] == id);
    if (index != -1) {
      meusAgendamentosCliente[index]['status'] = 'Cancelado';
    }
  }
}
