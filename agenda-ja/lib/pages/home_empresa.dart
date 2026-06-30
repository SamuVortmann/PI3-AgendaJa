import 'package:flutter/material.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import '../services/auth_service.dart';
import '../services/auth_session.dart';
import '../utils/date_utils.dart';
import 'cadastro_empresa.dart';

class HomeEmpresaPage extends StatefulWidget {
  const HomeEmpresaPage({super.key});

  @override
  State<HomeEmpresaPage> createState() => _HomeEmpresaPageState();
}

class _HomeEmpresaPageState extends State<HomeEmpresaPage> {
  int _hoje = 0;
  int _semana = 0;
  int _mes = 0;
  List<Agendamento> _agendamentosHoje = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    try {
      final dash = await AgendamentoService.instance.dashboard();
      final ags = await AgendamentoService.instance.listarAdmin(visao: 'semana');
      if (mounted) {
        setState(() {
          _hoje = dash.hoje;
          _semana = dash.semana;
          _mes = dash.mes;
          _agendamentosHoje = ags.where((a) => !a.isCancelado && a.isFuturo).toList()
            ..sort((a, b) => a.dataHoraInicio.compareTo(b.dataHoraInicio));
        });
      }
    } catch (_) {}
    finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _sair() async {
    await AuthService.instance.logout();
    if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final nome = AuthSession.instance.usuario?.nome ?? 'Admin';

    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              color: const Color(0xFF111934),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: _sair,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo.png', width: 80, errorBuilder: (_, __, ___) => const Text('A', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold))),
                        const Text('Agenda Já', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: _carregando
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: _carregar,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: Text(nome, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500))),
                              const SizedBox(height: 35),
                              const Text('Resumo:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(color: const Color(0xFF111934), borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('→ Hoje: $_hoje agendamentos', style: const TextStyle(color: Colors.white)),
                                    Text('→ Esta semana: $_semana', style: const TextStyle(color: Colors.white)),
                                    Text('→ Este mês: $_mes', style: const TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Text('Próximos agendamentos (semana):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(color: const Color(0xFF111934), borderRadius: BorderRadius.circular(15)),
                                child: _agendamentosHoje.isEmpty
                                    ? const Text('Nenhum agendamento nesta semana', style: TextStyle(color: Colors.white70))
                                    : Column(
                                        children: _agendamentosHoje.map((ag) => Padding(
                                              padding: const EdgeInsets.only(bottom: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      '${formatarHora(ag.dataHoraInicio)} - ${ag.clienteNome ?? "Cliente"} (${ag.servicoNome})',
                                                      style: const TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                  Text(statusLabel(ag.status), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                                                ],
                                              ),
                                            )).toList(),
                                      ),
                              ),
                              const SizedBox(height: 40),
                              botaoAcao('Ver agenda completa', () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const AgendaPage()));
                              }),
                              const SizedBox(height: 15),
                              botaoAcao('Gerenciar serviços e profissionais', () {
                                Navigator.pushNamed(context, '/admin_gestao');
                              }),
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

  Widget botaoAcao(String titulo, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF111934),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
