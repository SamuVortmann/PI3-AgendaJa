import 'package:flutter/material.dart';

import 'perfil_empresa.dart';
import 'agenda_empresa.dart';
import 'lista_clientes.dart';
import 'notificacoes_empresa.dart'; 

class HomeEmpresaPage extends StatefulWidget {
  const HomeEmpresaPage({super.key});

  @override
  State<HomeEmpresaPage> createState() => _HomeEmpresaPageState();
}

class _HomeEmpresaPageState extends State<HomeEmpresaPage> {
  int _selectedIndex = 0;
  final String _nomeEmpresa = 'Salão Bella';

  // Método para abrir páginas e resetar o índice ao voltar
  Future<void> _abrir(Widget pagina) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => pagina));
    if (mounted) {
      setState(() => _selectedIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2937), // Azul marinho consistente
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // CABEÇALHO
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Olá, $_nomeEmpresa!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      _abrir(const NotificacoesEmpresaPage());
                    },
                  ),
                ],
              ),
            ),

            // CONTEÚDO BRANCO COM A BORDA DE 60px
            Expanded(
              child: Container(
                width: double.infinity,
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
                      // Cards de Resumo
                      Row(
                        children: [
                          _buildSummaryCard(
                            Icons.calendar_today_outlined,
                            '8',
                            'Hoje',
                          ),
                          const SizedBox(width: 16),
                          _buildSummaryCard(
                            Icons.trending_up,
                            '92%',
                            'Comparecimento',
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      const Text(
                        'Agenda de hoje',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildAgendamentoItem('Maria Silva', 'Corte de cabelo - 14:00', const Color(0xFF22C55E)),
                      _buildAgendamentoItem('João Pereira', 'Barba - 15:00', const Color(0xFFF59E0B)),
                      _buildAgendamentoItem('Ana Costa', 'Manicure - 16:30', const Color(0xFF22C55E)),
                    ],
                  ),
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
          switch (index) {
            case 1:
              _abrir(AgendaPage(nomeEmpresa: _nomeEmpresa));
              break;
            case 2:
              _abrir(const ListaClientesPage());
              break;
            case 3:
              // LIGAÇÃO PARA A PÁGINA DE PERFIL DA EMPRESA
              _abrir(const PerfilEmpresaPage());
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu), // Ícone conforme o seu código original
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(IconData icon, String valor, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF2563EB), size: 24),
            const SizedBox(height: 12),
            Text(
              valor,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgendamentoItem(String nome, String detalhe, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(Icons.person, color: Color(0xFFD1D5DB)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1F2937)),
                ),
                const SizedBox(height: 4),
                Text(
                  detalhe,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 24,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}
