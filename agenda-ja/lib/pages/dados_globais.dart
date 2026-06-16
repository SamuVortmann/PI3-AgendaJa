class DadosGlobais {
  // Lista de empresas cadastradas (conforme sua estrutura)
  static List<Map<String, String>> empresasCadastradas = [];

  // Mapa de agendamentos por data (conforme sua estrutura)
  static Map<String, List<Map<String, String>>> agendamentos = {
    '2026-05-28': [
      {
        'nome': 'Ana Beatriz da Silva',
        'horario': '09:00',
        'telefone': '(11) 98888-7777',
        'status': 'Pendente',
        'data': '2026-05-28', // Adicionado para facilitar busca de histórico
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

  // Função para adicionar uma nova empresa (conforme sua estrutura)
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

  // Função para buscar agendamentos de uma data específica (conforme sua estrutura)
  static List<Map<String, String>> getAgendamentosPorData(String data) {
    return agendamentos[data] ?? [];
  }

  // --- FUNÇÕES ADICIONAIS PARA FUNCIONALIDADE TOTAL ---

  // Função para adicionar um novo agendamento dinamicamente
  static void adicionarAgendamento(Map<String, String> novoAgendamento) {
    String data = novoAgendamento['data'] ?? 'sem-data';
    if (!agendamentos.containsKey(data)) {
      agendamentos[data] = [];
    }
    agendamentos[data]!.add(novoAgendamento);
  }

  // Função para buscar o histórico de um cliente em todas as datas
  static List<Map<String, String>> getHistoricoCliente(String nomeCliente) {
    List<Map<String, String>> historico = [];
    agendamentos.forEach((data, lista) {
      for (var ag in lista) {
        if (ag['nome'] == nomeCliente) {
          historico.add(ag);
        }
      }
    });
    return historico;
  }

  // Obter o último atendimento (ex: o primeiro encontrado no histórico)
  static Map<String, String>? getUltimoAtendimento(String nomeCliente) {
    final historico = getHistoricoCliente(nomeCliente);
    return historico.isNotEmpty ? historico.first : null;
  }

  // Obter o próximo atendimento (ex: o segundo encontrado no histórico)
  static Map<String, String>? getProximoAtendimento(String nomeCliente) {
    final historico = getHistoricoCliente(nomeCliente);
    return historico.length > 1 ? historico[1] : null;
  }

  // Obter atendimentos cancelados
  static List<Map<String, String>> getCancelados(String nomeCliente) {
    return getHistoricoCliente(
      nomeCliente,
    ).where((ag) => ag['status']?.toLowerCase() == 'cancelado').toList();
  }
}
