import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import '../services/auth_session.dart';
import '../services/auth_service.dart';
import 'admin_gestao_page.dart';
import 'agenda_empresa.dart';
import 'lista_clientes.dart';

class HomeEmpresaPage extends StatefulWidget {
  const HomeEmpresaPage({super.key});

  @override
  State<HomeEmpresaPage> createState() => _HomeEmpresaPageState();
}

class _HomeEmpresaPageState extends State<HomeEmpresaPage> {
  int _selectedIndex = 0;
  DashboardTotais? _totais;
  List<Agendamento> _agendamentosHoje = [];
  bool _carregando = true;
  String? _erro;

  String get _nomeEmpresa {
    final usuario = AuthSession.instance.usuario;
    return usuario?.empresaNome ?? usuario?.nome ?? 'Empresa';
  }

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final resultados = await Future.wait([
        AgendamentoService.instance.dashboard(),
        AgendamentoService.instance.listarAdmin(visao: 'hoje'),
      ]);
      if (!mounted) return;
      setState(() {
        _totais = resultados[0] as DashboardTotais;
        _agendamentosHoje = resultados[1] as List<Agendamento>;
      });
    } catch (e) {
      if (mounted) setState(() => _erro = e.toString());
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _abrir(Widget pagina) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => pagina));
    if (mounted) {
      setState(() => _selectedIndex = 0);
      _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2937),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1F2937),
        elevation: 0,
        title: Text(
          'Olá, $_nomeEmpresa!',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: () async {
              await AuthService.instance.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              }
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
        ),
        child: _carregando
            ? const Center(child: CircularProgressIndicator())
            : _erro != null
            ? _erroView()
            : RefreshIndicator(
                onRefresh: _carregar,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                  children: [
                    Row(
                      children: [
                        _buildCard(
                          Icons.calendar_today,
                          '${_totais?.hoje ?? 0}',
                          'Hoje',
                        ),
                        const SizedBox(width: 12),
                        _buildCard(
                          Icons.date_range,
                          '${_totais?.semana ?? 0}',
                          'Esta semana',
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Agenda de hoje',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_agendamentosHoje.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 36),
                        child: Center(
                          child: Text('Nenhum agendamento para hoje.'),
                        ),
                      )
                    else
                      ..._agendamentosHoje.map(_buildAgendamentoItem),
                  ],
                ),
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
              _abrir(const AdminGestaoPage());
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Gestão',
          ),
        ],
      ),
    );
  }

  Widget _erroView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_erro!, textAlign: TextAlign.center),
          ),
          ElevatedButton(
            onPressed: _carregar,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String valor, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF3B82F6), size: 20),
            const SizedBox(height: 12),
            Text(
              valor,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgendamentoItem(Agendamento agendamento) {
    final cores = {
      'confirmado': const Color(0xFF10B981),
      'pendente': const Color(0xFFF59E0B),
      'cancelado': const Color(0xFFEF4444),
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            child: Text((agendamento.clienteNome ?? '?')[0].toUpperCase()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agendamento.clienteNome ?? 'Cliente',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${agendamento.servicoNome ?? 'Serviço'} - ${DateFormat('HH:mm').format(agendamento.dataHoraInicio.toLocal())}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: cores[agendamento.status] ?? Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              agendamento.status,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
