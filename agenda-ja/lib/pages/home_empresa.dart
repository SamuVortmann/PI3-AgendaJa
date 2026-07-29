import 'package:flutter/material.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import '../services/auth_service.dart';
import '../services/auth_session.dart';
import '../utils/date_utils.dart';
import 'agenda_empresa.dart'; 

class HomeEmpresaPage extends StatefulWidget {
  const HomeEmpresaPage({super.key});

  @override
  State<HomeEmpresaPage> createState() => _HomeEmpresaPageState();
}

class _HomeEmpresaPageState extends State<HomeEmpresaPage> {
  int _hoje = 0;
  String _comparecimento = "92%";
  List<Agendamento> _agendamentosHoje = [];
  bool _carregando = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    try {
      final dash = await AgendamentoService.instance.dashboard();
      final ags = await AgendamentoService.instance.listarAdmin(visao: 'dia');
      if (mounted) {
        setState(() {
          _hoje = dash.hoje;
          _agendamentosHoje = ags.where((a) => !a.isCancelado).toList()
            ..sort((a, b) => a.dataHoraInicio.compareTo(b.dataHoraInicio));
        });
      }
    } catch (_) {}
    finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nomeEmpresa = AuthSession.instance.usuario?.nome ?? 'Salão Bella';

    return Scaffold(
      backgroundColor: const Color(0xFF1F2937), // Fundo azul marinho para o efeito do canto
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho azul marinho
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              color: const Color(0xFF1F2937),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Olá, $nomeEmpresa!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                ],
              ),
            ),
            
            // Corpo branco com CANTO SUPERIOR ESQUERDO ARREDONDADO (60px)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60), // O detalhe solicitado
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
                          _cardResumo(Icons.calendar_today, '$_hoje', 'Hoje'),
                          const SizedBox(width: 16),
                          _cardResumo(Icons.trending_up, _comparecimento, 'Comparecimento'),
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
                      const SizedBox(height: 16),
                      
                      if (_carregando)
                        const Center(child: CircularProgressIndicator())
                      else if (_agendamentosHoje.isEmpty)
                        const Center(child: Text('Nenhum agendamento para hoje'))
                      else
                        ..._agendamentosHoje.map((ag) => _itemAgenda(ag)).toList(),
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
          if (index == 1) {
             Navigator.push(context, MaterialPageRoute(builder: (_) => AgendaPage(nomeEmpresa: nomeEmpresa)));
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

  Widget _cardResumo(IconData icone, String valor, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone, color: const Color(0xFF2563EB), size: 20),
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
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemAgenda(Agendamento ag) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFF3F4F6),
            child: Text(
              ag.clienteNome?.substring(0, 1).toUpperCase() ?? 'C',
              style: const TextStyle(color: Color(0xFF9CA3AF)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ag.clienteNome ?? 'Cliente',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  '${ag.servicoNome} - ${formatarHora(ag.dataHoraInicio)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 24,
            decoration: BoxDecoration(
              color: ag.status == 'confirmado' ? const Color(0xFF22C55E) : const Color(0xFFF59E0B),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}
