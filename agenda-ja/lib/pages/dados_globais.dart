class DadosGlobais {
  // Nome do usuário centralizado
  static String nomeUsuario = 'Ana Beatriz da Silva';
  static String telefoneUsuario = '(11) 98888-7777';

  // 1. Lista de empresas cadastradas
  static List<Map<String, String>> empresasCadastradas = [];

  // 2. Mapa de agendamentos por data (Visão Empresa)
  static Map<String, List<Map<String, String>>> agendamentos = {
    '2026-05-28': [
      {
        'nome': 'Ana Beatriz da Silva',
        'horario': '09:00',
        'telefone': '(11) 98888-7777',
        'status': 'Pendente',
        'data': '2026-05-28',
      },
      {
        'nome': 'Ronaldo dos Santos',
        'horario': '10:00',
        'telefone': '(11) 97777-6666',
        'status': 'Pendente',
        'data': '2026-05-28',
      },
      {
        'nome': 'Felipe da Penha',
        'horario': '11:00',
        'telefone': '(11) 96666-5555',
        'status': 'Pendente',
        'data': '2026-05-28',
      },
    ],
  };

  // 3. Lista de Meus Agendamentos (Visão Cliente)
  static List<Map<String, dynamic>> meusAgendamentosCliente = [
    {
      'id': '1',
      'data': '10/06/2026',
      'local': 'Clinica Tesser - Concórdia',
      'horario': '16:50',
      'status': 'Futuro',
    },
    {
      'id': '2',
      'data': '25/07/2026',
      'local': 'Hospital São Francisco',
      'horario': '08:10',
      'status': 'Futuro',
    },
    {
      'id': '3',
      'data': '28/05/2026',
      'local': 'Clinica Vida - Concórdia',
      'horario': '15:30',
      'status': 'Futuro', // Alterado para Futuro para aparecer no calendário
    },
    {
      'id': '4',
      'data': '28/05/2026',
      'local': 'Salão Bela Vista - Irani',
      'horario': '18:00',
      'status': 'Futuro', // Alterado para Futuro para aparecer no calendário
    },
  ];

  // --- FUNÇÕES CORE ---

  // Adicionar empresa
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

  // Buscar agendamentos por data (Visão Empresa)
  static List<Map<String, String>> getAgendamentosPorData(String data) {
    return agendamentos[data] ?? [];
  }

  // Cancelar agendamento do cliente
  static void cancelarAgendamento(String id) {
    int index = meusAgendamentosCliente.indexWhere((ag) => ag['id'] == id);
    if (index != -1) {
      meusAgendamentosCliente[index]['status'] = 'Cancelado';
    }
  }

  // Remarcar agendamento do cliente
  static void remarcarAgendamento(String id, String novaData, String novoHorario) {
    int index = meusAgendamentosCliente.indexWhere((ag) => ag['id'] == id);
    if (index != -1) {
      meusAgendamentosCliente[index]['data'] = novaData;
      meusAgendamentosCliente[index]['horario'] = novoHorario;
      meusAgendamentosCliente[index]['status'] = 'Remarcado';
    }
  }

  // Adicionar novo agendamento dinamicamente
  static void adicionarAgendamento(Map<String, String> novoAgendamento) {
    String data = novoAgendamento['data'] ?? 'sem-data';
    if (!agendamentos.containsKey(data)) {
      agendamentos[data] = [];
    }
    agendamentos[data]!.add(novoAgendamento);
  }

  // --- FUNÇÕES DE HISTÓRICO E ESTATÍSTICAS ---

  // Buscar histórico completo de um cliente
  static List<Map<String, String>> getHistoricoCliente(String nomeCliente) {
    List<Map<String, String>> historico = [];
    agendamentos.forEach((data, lista) {
      for (var agendamento in lista) {
        if (agendamento['nome'] == nomeCliente) {
          historico.add(agendamento);
        }
      }
    });
    return historico;
  }

  // Último atendimento
  static Map<String, String>? getUltimoAtendimento(String nomeCliente) {
    final historico = getHistoricoCliente(nomeCliente);
    return historico.isNotEmpty ? historico.first : null;
  }

  // Próximo atendimento
  static Map<String, String>? getProximoAtendimento(String nomeCliente) {
    final historico = getHistoricoCliente(nomeCliente);
    return historico.length > 1 ? historico[1] : null;
  }

  // Atendimentos cancelados
  static List<Map<String, String>> getCancelados(String nomeCliente) {
    return getHistoricoCliente(nomeCliente)
        .where((ag) => ag['status']?.toLowerCase() == 'cancelado')
        .toList();
  }
}
