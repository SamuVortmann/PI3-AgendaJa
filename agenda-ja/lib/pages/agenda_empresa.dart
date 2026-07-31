import 'package:flutter/material.dart';

class AgendaPage extends StatefulWidget {
  final String nomeEmpresa;

  const AgendaPage({super.key, required this.nomeEmpresa});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  int _selectedIndex = 1;
  DateTime dataSelecionada = DateTime(2026, 7, 30);

  // Dados estáticos de agendamentos
  final List<Map<String, String>> agendamentosHoje = [
    {
      'nome': 'Maria Silva',
      'servico': 'Corte de cabelo',
      'hora': '14:00',
      'status': 'confirmado',
    },
    {
      'nome': 'João Pereira',
      'servico': 'Barba',
      'hora': '15:00',
      'status': 'pendente',
    },
    {
      'nome': 'Ana Costa',
      'servico': 'Manicure',
      'hora': '16:30',
      'status': 'confirmado',
    },
    {
      'nome': 'Bia Lima',
      'servico': 'Escova',
      'hora': '17:30',
      'status': 'cancelado',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2937),
      body: Column(
        children: [
          // APPBAR ARREDONDADO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF1F2937),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Agenda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // CORPO COM BORDA ARREDONDADA
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CALENDÁRIO - DIAS DA SEMANA
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Dias da semana
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildDiaCalendario('Seg', 28, false),
                              _buildDiaCalendario('Ter', 29, false),
                              _buildDiaCalendario('Qua', 30, true),
                              _buildDiaCalendario('Qui', 31, false),
                              _buildDiaCalendario('Sex', 1, false),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Data selecionada
                          Text(
                            'Quarta, 30 de Julho',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // LISTA DE AGENDAMENTOS
                    const Text(
                      'Agendamentos do dia',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...agendamentosHoje.map((ag) => _buildAgendamentoItem(ag)).toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Clientes'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Mais'),
        ],
      ),
    );
  }

  Widget _buildDiaCalendario(String dia, int numero, bool selecionado) {
    return Column(
      children: [
        Text(
          dia,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: selecionado ? const Color(0xFF1F2937) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              numero.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: selecionado ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgendamentoItem(Map<String, String> agendamento) {
    final isConfirmado = agendamento['status'] == 'confirmado';
    final isPendente = agendamento['status'] == 'pendente';
    final isCancelado = agendamento['status'] == 'cancelado';

    Color statusColor;
    if (isConfirmado) {
      statusColor = const Color(0xFF10B981);
    } else if (isPendente) {
      statusColor = const Color(0xFFF59E0B);
    } else {
      statusColor = const Color(0xFFEF4444);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFF3F4F6),
            child: Text(
              agendamento['nome']![0].toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Informações
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agendamento['nome']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${agendamento['servico']} - ${agendamento['hora']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const SizedBox(
              width: 20,
              height: 12,
            ),
          ),
        ],
      ),
    );
  }
}
