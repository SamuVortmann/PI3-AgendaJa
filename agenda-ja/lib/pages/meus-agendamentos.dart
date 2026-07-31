import 'package:flutter/material.dart';
import 'detalhes_agendamento.dart';

class MeusAgendamentosPage extends StatefulWidget {
  const MeusAgendamentosPage({super.key});

  @override
  State<MeusAgendamentosPage> createState() => _MeusAgendamentosPageState();
}

class _MeusAgendamentosPageState extends State<MeusAgendamentosPage> {
  String _filtroAtual = 'Futuros';
  int _selectedIndex = 1;

  // DADOS ESTÁTICOS (Puro Front-End)
  final List<Map<String, dynamic>> _agendamentosMock = [
    {
      'servico': 'Corte de cabelo',
      'profissional': 'Ana Souza',
      'data': 'Qui, 30 Jul - 14:00',
      'status': 'confirmado',
      'tipo': 'Futuros',
    },
    {
      'servico': 'Manicure',
      'profissional': 'Bia Lima',
      'data': 'Sex, 31 Jul - 10:00',
      'status': 'pendente',
      'tipo': 'Passados',
    },
    {
      'servico': 'Barba',
      'profissional': 'Ana Souza',
      'data': 'Sáb, 01 Ago - 09:00',
      'status': 'cancelado',
      'tipo': 'Cancelados',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2937),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              width: double.infinity,
              child: const Text(
                'Meus agendamentos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _buildFilterChip('Futuros'),
                          const SizedBox(width: 12),
                          _buildFilterChip('Passados'),
                          const SizedBox(width: 12),
                          _buildFilterChip('Cancelados'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        children: _agendamentosMock
                            .where((ag) => ag['tipo'] == _filtroAtual)
                            .map((ag) => _buildAgendamentoCard(ag))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 0) Navigator.pop(context);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Avisos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _filtroAtual == label;
    return GestureDetector(
      onTap: () => setState(() => _filtroAtual = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAgendamentoCard(Map<String, dynamic> ag) {
    Color statusColor = const Color(0xFF22C55E);
    if (ag['status'] == 'cancelado') {
      statusColor = const Color(0xFFEF4444);
    } else if (ag['status'] == 'pendente') {
      statusColor = const Color(0xFFF59E0B);
    }

    return GestureDetector(
      onTap: () {
        // NAVEGAÇÃO DIRETA PARA A PÁGINA DE DETALHES
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalhesAgendamentoPage(agendamento: ag),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3F4F6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ag['servico'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                    ),
                    Text(
                      'com ${ag['profissional']}',
                      style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                    ),
                  ],
                ),
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF3F4F6)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 8),
                Text(ag['data'], style: const TextStyle(color: Color(0xFF9CA3AF), fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
