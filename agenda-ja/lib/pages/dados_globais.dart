class DadosGlobais {
  // Lista de empresas cadastradas
  static List<Map<String, String>> empresasCadastradas = [];

  // Mapa de agendamentos por data
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

  // Lista de agendamentos do cliente
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
      'status': 'Passado',
    },
    {
      'id': '4',
      'data': '28/05/2026',
      'local': 'Salão Bela Vista - Irani',
      'horario': '18:00',
      'status': 'Cancelado',
    },
  ];

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

  // Buscar agendamentos por data
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

  // Adicionar novo agendamento
  static void adicionarAgendamento(Map<String, String> novoAgendamento) {
    String data = novoAgendamento['data'] ?? 'sem-data';

    if (!agendamentos.containsKey(data)) {
      agendamentos[data] = [];
    }

    agendamentos[data]!.add(novoAgendamento);
  }

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

    if (historico.isNotEmpty) {
      return historico.first;
    }

    return null;
  }

  // Próximo atendimento
  static Map<String, String>? getProximoAtendimento(String nomeCliente) {
    final historico = getHistoricoCliente(nomeCliente);

    if (historico.length > 1) {
      return historico[1];
    }

    return null;
  }

  // Atendimentos cancelados
  static List<Map<String, String>> getCancelados(String nomeCliente) {
    return getHistoricoCliente(nomeCliente)
        .where(
          (agendamento) => agendamento['status']?.toLowerCase() == 'cancelado',
        )
        .toList();
  }
}
