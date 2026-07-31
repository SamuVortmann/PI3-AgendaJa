import 'package:flutter/material.dart';
import 'package:piteste/pages/agenda_empresa.dart';
import 'agenda_empresa.dart';

class HomeEmpresaPage extends StatefulWidget {
  const HomeEmpresaPage({super.key});

  @override
  State<HomeEmpresaPage> createState() => _HomeEmpresaPageState();
}

class _HomeEmpresaPageState extends State<HomeEmpresaPage> {
  int _selectedIndex = 0;
  final String nomeEmpresa = 'Salão Bella';

  // Dados estáticos para agendamentos
  final List<Map<String, dynamic>> _agendamentosHoje = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2937),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2937),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Olá, Salão Bella!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Corpo com conteúdo
          Expanded(
            child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        // Cards de Resumo
                      Row(
                      children: [
                        _buildCard(
                          icon: Icons.calendar_today,
                          valor: '8',
                          label: 'Hoje',
                          iconColor: const Color(0xFF3B82F6),
                        ),
                        const SizedBox(width: 12),
                        _buildCard(
                          icon: Icons.trending_up,
                          valor: '92%',
                          label: 'Comparecimento',
                          iconColor: const Color(0xFF3B82F6),
                        ),
                      ],
                      ),
                      const SizedBox(height: 32),

                      // Título "Agenda de hoje"
                      const Text(
                        'Agenda de hoje',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Lista de agendamentos
                      ..._agendamentosHoje.map((ag) => _buildAgendamentoItem(ag)).toList(),
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
        onTap: (index) {
          setState(() => _selectedIndex = index);
          switch (index) {
            case 0:
              // Já está na Home
              break;
            case 1:
              // Navegar para Agenda
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AgendaPage(nomeEmpresa: nomeEmpresa),
                ),
              ).then((_) {
                setState(() => _selectedIndex = 0);
              });
              break;
            case 2:
              // TODO: Navegar para página de Clientes
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Página de Clientes em desenvolvimento')),
              );
              break;
            case 3:
              // TODO: Navegar para página de Mais
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Página de Mais em desenvolvimento')),
              );
              break;
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

  Widget _buildCard({
    required IconData icon,
    required String valor,
    required String label,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 12),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgendamentoItem(Map<String, dynamic> agendamento) {
    final isConfirmado = agendamento['status'] == 'confirmado';
    final statusColor = isConfirmado ? const Color(0xFF10B981) : const Color(0xFFF59E0B);

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
              agendamento['nome'][0].toUpperCase(),
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
                  agendamento['nome'],
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
            child: Text(
              isConfirmado ? 'Confirmado' : 'Pendente',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
