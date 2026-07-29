import 'package:flutter/material.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import '../services/api_client.dart';
import '../services/auth_session.dart';
import '../utils/date_utils.dart';
import 'detalhes_agendamento.dart';
import 'perfil_cliente.dart';

class MeusAgendamentosPage extends StatefulWidget {
  const MeusAgendamentosPage({super.key});

  @override
  State<MeusAgendamentosPage> createState() => _MeusAgendamentosPageState();
}

class _MeusAgendamentosPageState extends State<MeusAgendamentosPage> {
  List<Agendamento> _agendamentos = [];
  bool _carregando = true;
  String _filtroAtual = 'Futuros';

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    try {
      final ags = await AgendamentoService.instance.meusAgendamentos();
      if (mounted) setState(() => _agendamentos = ags);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  List<Agendamento> get _agendamentosFiltrados {
    if (_filtroAtual == 'Futuros') {
      return _agendamentos.where((a) => a.isFuturo && !a.isCancelado).toList();
    } else if (_filtroAtual == 'Passados') {
      return _agendamentos.where((a) => a.isPassado && !a.isCancelado).toList();
    } else {
      return _agendamentos.where((a) => a.isCancelado).toList();
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) return;

    final usuario = AuthSession.instance.usuario!;
    
    switch (index) {
      case 0:
        Navigator.pop(context);
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PerfilPage(nome: usuario.nome, telefone: usuario.telefone ?? ''),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934), // Fundo azul para o arredondamento aparecer
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO AZUL
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              color: const Color(0xFF111934),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Meus agendamentos',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(45)),
                ),
                child: Column(
                  children: [
                    // FILTROS
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildFilterChip('Futuros'),
                          _buildFilterChip('Passados'),
                          _buildFilterChip('Cancelados'),
                        ],
                      ),
                    ),
                    
                    Expanded(
                      child: _carregando
                          ? const Center(child: CircularProgressIndicator())
                          : RefreshIndicator(
                              onRefresh: _carregar,
                              child: _agendamentosFiltrados.isEmpty
                                  ? ListView(
                                      children: const [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(40),
                                            child: Text('Nenhum agendamento encontrado.', style: TextStyle(color: Colors.grey)),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      itemCount: _agendamentosFiltrados.length,
                                      itemBuilder: (context, index) {
                                        return _buildAgendamentoCard(_agendamentosFiltrados[index]);
                                      },
                                    ),
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
        currentIndex: 1,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF111934),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none_outlined), activeIcon: Icon(Icons.notifications), label: 'Avisos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _filtroAtual == label;
    return GestureDetector(
      onTap: () => setState(() => _filtroAtual = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF111934) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAgendamentoCard(Agendamento ag) {
    Color statusColor = const Color(0xFF2ECC71);
    if (ag.isCancelado) {
      statusColor = const Color(0xFFE74C3C);
    } else if (ag.isPassado) {
      statusColor = const Color(0xFFF39C12);
    }

    return GestureDetector(
      onTap: () async {
        if (!ag.isCancelado) {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetalhesAgendamentoPage(agendamento: ag)),
          );
          _carregar();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
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
                      ag.servicoNome ?? 'Serviço',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111934)),
                    ),
                    Text(
                      'com ${ag.profissionalNome ?? "Profissional"}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
                Container(
                  width: 60,
                  height: 25,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${formatarData(ag.dataHoraInicio)} · ${formatarHora(ag.dataHoraInicio)}',
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
