import 'package:flutter/material.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import '../utils/date_utils.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  List<Agendamento> _agendamentos = [];
  bool _carregando = true;

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

  List<Map<String, String>> get notificacoes {
    final lista = <Map<String, String>>[];
    final agora = DateTime.now();

    for (final ag in _agendamentos) {
      if (ag.isCancelado) continue;

      if (ag.status == 'confirmado') {
        lista.add({
          'icon': '✔',
          'text': 'Seu horário foi confirmado\n${formatarData(ag.dataHoraInicio)} • ${formatarHora(ag.dataHoraInicio)} • ${ag.servicoNome}',
        });
      }

      final diff = ag.dataHoraInicio.difference(agora);
      if (diff.inHours >= 20 && diff.inHours <= 28 && ag.isFuturo) {
        lista.add({
          'icon': '⏰',
          'text': 'Você tem um horário amanhã\n${formatarHora(ag.dataHoraInicio)} • ${ag.servicoNome}',
        });
      }

      if (ag.status == 'pendente' && ag.isFuturo) {
        lista.add({
          'icon': '📋',
          'text': 'Agendamento pendente de confirmação\n${formatarData(ag.dataHoraInicio)} • ${ag.servicoNome}',
        });
      }
    }

    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: const Color(0xFF111934),
              child: Column(
                children: [
                  Image.asset('assets/logo.png', width: 60, errorBuilder: (_, __, ___) => const Text('A', style: TextStyle(color: Colors.white, fontSize: 28))),
                  const SizedBox(height: 20),
                  const Text('Notificações', style: TextStyle(color: Colors.white, fontSize: 32)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: _carregando
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: _carregar,
                        child: notificacoes.isEmpty
                            ? const ListTile(title: Text('Nenhuma notificação no momento'))
                            : ListView.builder(
                                padding: const EdgeInsets.all(30),
                                itemCount: notificacoes.length,
                                itemBuilder: (_, i) {
                                  final n = notificacoes[i];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _buildNotificationCard(icon: n['icon']!, text: n['text']!),
                                  );
                                },
                              ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({required String icon, required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, height: 1.3))),
        ],
      ),
    );
  }
}
