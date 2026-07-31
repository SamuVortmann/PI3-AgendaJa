import 'package:flutter/material.dart';
import '../services/auth_session.dart';
import '../services/agendamento_service.dart';
import '../utils/date_utils.dart';
import 'agendar.dart';
import 'meus-agendamentos.dart';
import 'perfil_cliente.dart';
import 'notificacoes.dart'; // Certifique-se de que o nome do arquivo é este

class HomeClientePage extends StatefulWidget {
  const HomeClientePage({super.key});

  @override
  State<HomeClientePage> createState() => _HomeClientePageState();
}

class _HomeClientePageState extends State<HomeClientePage> {
  int _selectedIndex = 0;
  bool _carregando = false;

  @override
  Widget build(BuildContext context) {
    final usuario = AuthSession.instance.usuario!;

    return Scaffold(
      backgroundColor: const Color(0xFF1F2937), // Fundo azul marinho
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO (Ícone de notificação removido conforme solicitado)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Olá,', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Text(
                    usuario.nome,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            // CORPO BRANCO COM CANTO ARREDONDADO (60px)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      
                      // BARRA DE PESQUISA
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.search, color: Color(0xFF9CA3AF)),
                            hintText: 'Buscar serviço ou profissional',
                            hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),

                      // BOTÃO AGENDAR (Novo)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AgendarPage()),
                            );
                          },
                          icon: const Icon(Icons.calendar_today, color: Colors.white),
                          label: const Text(
                            'Agendar agora',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // PRÓXIMO AGENDAMENTO
                      const Text(
                        'Próximo agendamento',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                      ),
                      const SizedBox(height: 16),
                      _cardProximoAgendamento(),
                      
                      const SizedBox(height: 32),
                      
                      // SERVIÇOS EM DESTAQUE
                      const Text(
                        'Serviços em destaque',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                      ),
                      const SizedBox(height: 16),
                      _itemServico('Corte de Cabelo', '45 min', 'R 45,00'),
                      _itemServico('Manicure', '40 min', 'R 35,00'),
                      _itemServico('Barba', '25 min', 'R 25,00'),
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
          if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => const MeusAgendamentosPage()));
          if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificacoesPage())); // LIGAÇÃO CORRIGIDA
          if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (_) => PerfilPage(nome: usuario.nome, telefone: usuario.telefone ?? '')));
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

  Widget _cardProximoAgendamento() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Corte de cabelo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('com Ana Souza', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Container(
                width: 60,
                height: 24,
                decoration: BoxDecoration(color: const Color(0xFF22C55E), borderRadius: BorderRadius.circular(12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.access_time, size: 18, color: Colors.grey),
              SizedBox(width: 8),
              Text('Qui, 30 Jul - 14:00', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemServico(String nome, String tempo, String preco) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.content_cut, color: Color(0xFF1F2937)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(tempo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(preco, style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
