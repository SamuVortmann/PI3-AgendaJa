import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import '../services/auth_session.dart';
import 'agenda_empresa.dart';
import 'lista_clientes.dart';
import 'notificacoes_empresa.dart';
import 'perfil_empresa.dart';

class HomeEmpresaPage extends StatefulWidget {
  const HomeEmpresaPage({super.key});

  @override
  State<HomeEmpresaPage> createState() => _HomeEmpresaPageState();
}

class _HomeEmpresaPageState extends State<HomeEmpresaPage> {
  int _selectedIndex = 0;
  DashboardTotais? _totais;
  List<Agendamento> _agendamentosHoje = [];
  List<Agendamento> _agendamentosSemana = [];
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
        AgendamentoService.instance.listarAdmin(),
        AgendamentoService.instance.listarAdmin(visao: 'semana'),
      ]);
      if (!mounted) return;
      setState(() {
        _totais = resultados[0] as DashboardTotais;
        _agendamentosHoje = resultados[1] as List<Agendamento>;
        _agendamentosSemana = resultados[2] as List<Agendamento>;
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
      await _carregar();
    }
  }

  Future<void> _cancelar(Agendamento agendamento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar agendamento?'),
        content: Text(
          '${agendamento.clienteNome ?? 'Cliente'} • '
          '${DateFormat('dd/MM/yyyy HH:mm').format(agendamento.dataHoraInicio.toLocal())}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Cancelar agendamento',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;
    try {
      await AgendamentoService.instance.atualizarAdmin(
        agendamento.id,
        status: 'cancelado',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Agendamento cancelado.')));
      await _carregar();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2937),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1F2937),
        foregroundColor: Colors.white,
        title: Text('Olá, $_nomeEmpresa!'),
        actions: [
          IconButton(
            tooltip: 'Avisos',
            icon: const Icon(Icons.notifications_none),
            onPressed: () => _abrir(const NotificacoesEmpresaPage()),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
        ),
        child: _conteudo(),
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
            icon: Icon(Icons.settings_outlined),
            label: 'Gestão',
          ),
        ],
      ),
    );
  }

  Widget _conteudo() {
    if (_carregando) return const Center(child: CircularProgressIndicator());
    if (_erro != null) {
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
    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        children: [
          Row(
            children: [
              _resumo(Icons.today, '${_totais?.hoje ?? 0}', 'Hoje'),
              const SizedBox(width: 12),
              _resumo(
                Icons.date_range,
                '${_totais?.semana ?? 0}',
                'Esta semana',
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Agenda de hoje',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_agendamentosHoje.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 36),
              child: Center(child: Text('Nenhum agendamento para hoje.')),
            )
          else
            ..._agendamentosHoje.map(_agendamentoCard),
          const SizedBox(height: 28),
          const Text(
            'Agenda da semana',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(_periodoSemana(), style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          if (_agendamentosSemana.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(child: Text('Nenhum agendamento nesta semana.')),
            )
          else
            ..._agendamentosSemana.map(
              (item) => _agendamentoCard(item, mostrarData: true),
            ),
        ],
      ),
    );
  }

  Widget _resumo(IconData icon, String valor, String titulo) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF2563EB)),
              const SizedBox(height: 10),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(titulo),
            ],
          ),
        ),
      ),
    );
  }

  String _periodoSemana() {
    final hoje = DateTime.now();
    final inicio = DateTime(
      hoje.year,
      hoje.month,
      hoje.day,
    ).subtract(Duration(days: hoje.weekday - DateTime.monday));
    final fim = inicio.add(const Duration(days: 6));
    return '${DateFormat('dd/MM').format(inicio)} – ${DateFormat('dd/MM/yyyy').format(fim)}';
  }

  Widget _agendamentoCard(Agendamento item, {bool mostrarData = false}) {
    final data = item.dataHoraInicio.toLocal();
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () =>
            _abrir(AgendaPage(nomeEmpresa: _nomeEmpresa, initialDate: data)),
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(item.clienteNome ?? 'Cliente'),
        subtitle: Text(
          '${item.servicoNome ?? 'Serviço'} • ${item.profissionalNome ?? 'Profissional'}\n'
          '${mostrarData ? '${DateFormat('dd/MM/yyyy').format(data)} • ' : ''}'
          '${DateFormat('HH:mm').format(data)} • ${item.statusLabel}',
        ),
        isThreeLine: true,
        trailing: item.isCancelado
            ? const Chip(label: Text('Cancelado'))
            : IconButton(
                tooltip: 'Cancelar agendamento',
                onPressed: () => _cancelar(item),
                icon: const Icon(Icons.cancel_outlined, color: Colors.red),
              ),
      ),
    );
  }
}
