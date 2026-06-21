import 'package:flutter/material.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import '../services/auth_session.dart';
import '../utils/date_utils.dart';
import 'agendar.dart';
import 'menu.dart';

class HomeClientePage extends StatefulWidget {
  const HomeClientePage({super.key});

  @override
  State<HomeClientePage> createState() => _HomeClientePageState();
}

class _HomeClientePageState extends State<HomeClientePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Agendamento> _agendamentos = [];
  bool _carregando = true;

  DateTime _mesAtual = DateTime(DateTime.now().year, DateTime.now().month);

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
    } catch (_) {
      if (mounted) setState(() => _agendamentos = []);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  List<Agendamento> get agendamentosDoMes {
    return _agendamentos.where((a) {
      return a.dataHoraInicio.year == _mesAtual.year &&
          a.dataHoraInicio.month == _mesAtual.month &&
          !a.isCancelado;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = AuthSession.instance.usuario!;
    final nome = usuario.nome;
    final telefone = usuario.telefone ?? '';

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF111934),
      drawer: MenuCliente(nome: nome, telefone: telefone),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              color: const Color(0xFF111934),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    icon: const Icon(Icons.menu, color: Colors.white, size: 34),
                  ),
                  Image.asset('assets/logo.png', width: 100,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image, color: Colors.white)),
                  const SizedBox(width: 34),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(45)),
                ),
                child: RefreshIndicator(
                  onRefresh: _carregar,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Olá, $nome!', style: const TextStyle(fontSize: 20, decoration: TextDecoration.underline)),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: 140,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AgendarPage()),
                              );
                              _carregar();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF111934),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('+ Agendar', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text('Sua agenda', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        _buildCalendario(),
                        const SizedBox(height: 30),
                        const Text('Agendamentos do mês', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 12),
                        if (_carregando)
                          const Center(child: CircularProgressIndicator())
                        else if (agendamentosDoMes.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                            child: const Text('Sem agendamentos', style: TextStyle(color: Colors.grey)),
                          )
                        else
                          ...agendamentosDoMes.map((a) => Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF111934),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${formatarData(a.dataHoraInicio)} • ${formatarHora(a.dataHoraInicio)} • ${a.servicoNome ?? "Serviço"}',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Text(statusLabel(a.status), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                  ],
                                ),
                              )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendario() {
    final diasNoMes = DateTime(_mesAtual.year, _mesAtual.month + 1, 0).day;
    final primeiroDia = DateTime(_mesAtual.year, _mesAtual.month, 1).weekday % 7;
    const meses = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF06153D)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => setState(() => _mesAtual = DateTime(_mesAtual.year, _mesAtual.month - 1)),
                icon: const Icon(Icons.arrow_back_ios, size: 18),
              ),
              Text('${meses[_mesAtual.month - 1]} ${_mesAtual.year}', style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () => setState(() => _mesAtual = DateTime(_mesAtual.year, _mesAtual.month + 1)),
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: diasNoMes + primeiroDia,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
            itemBuilder: (context, index) {
              if (index < primeiroDia) return const SizedBox();
              final dia = index - primeiroDia + 1;
              final temAg = _agendamentos.any((a) =>
                  !a.isCancelado &&
                  a.dataHoraInicio.year == _mesAtual.year &&
                  a.dataHoraInicio.month == _mesAtual.month &&
                  a.dataHoraInicio.day == dia);
              return Center(
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: temAg
                      ? BoxDecoration(
                          border: Border.all(color: const Color(0xFF111934)),
                          shape: BoxShape.circle,
                        )
                      : null,
                  child: Text('$dia', style: TextStyle(fontWeight: temAg ? FontWeight.bold : FontWeight.normal)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
