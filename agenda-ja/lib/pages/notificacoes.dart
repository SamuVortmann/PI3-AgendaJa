import 'package:flutter/material.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import '../services/api_client.dart';
import '../utils/date_utils.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  List<Agendamento> _agendamentos = [];
  bool _carregando = true;
  String? _erro;

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
      final ags = await AgendamentoService.instance.meusAgendamentos();
      if (mounted) setState(() => _agendamentos = ags);
    } on ApiException catch (e) {
      if (mounted) setState(() => _erro = e.message);
    } catch (e) {
      if (mounted) setState(() => _erro = e.toString());
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
          'text': 'Seu horário foi confirmado\n${formatarData(ag.dataHoraInicio)} • ${formatarHora(ag.dataHoraInicio)} • ${ag.servicoNome ?? "Serviço"}',
        });
      }

      final diff = ag.dataHoraInicio.difference(agora);
      if (diff.inHours >= 20 && diff.inHours <= 28 && ag.isFuturo) {
        lista.add({
          'icon': '⏰',
          'text': 'Você tem um horário amanhã\n${formatarHora(ag.dataHoraInicio)} • ${ag.servicoNome ?? "Serviço"}',
        });
      }

      if (ag.status == 'pendente' && ag.isFuturo) {
        lista.add({
          'icon': '📋',
          'text': 'Agendamento pendente de confirmação\n${formatarData(ag.dataHoraInicio)} • ${ag.servicoNome ?? "Serviço"}',
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
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              color: const Color(0xFF111934),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Notificações',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
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
                    : _erro != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_erro!, textAlign: TextAlign.center),
                                  const SizedBox(height: 12),
                                  ElevatedButton(onPressed: _carregar, child: const Text('Tentar novamente')),
                                ],
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _carregar,
                            child: notificacoes.isEmpty
                                ? ListView(
                                    children: const [
                                      SizedBox(height: 80),
                                      Center(child: Text('Nenhuma notificação no momento')),
                                    ],
                                  )
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
