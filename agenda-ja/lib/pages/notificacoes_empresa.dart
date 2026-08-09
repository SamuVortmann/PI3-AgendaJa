import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';

class NotificacoesEmpresaPage extends StatefulWidget {
  const NotificacoesEmpresaPage({super.key});

  @override
  State<NotificacoesEmpresaPage> createState() =>
      _NotificacoesEmpresaPageState();
}

class _NotificacoesEmpresaPageState extends State<NotificacoesEmpresaPage> {
  List<Agendamento> _itens = [];
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
      final itens = await AgendamentoService.instance.listarAdmin(
        visao: 'todos',
      );
      itens.sort(
        (a, b) => b.ultimaMovimentacao.compareTo(a.ultimaMovimentacao),
      );
      if (mounted) setState(() => _itens = itens);
    } catch (e) {
      if (mounted) setState(() => _erro = e.toString());
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Avisos da empresa')),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
          ? Center(child: Text(_erro!))
          : _itens.isEmpty
          ? const Center(child: Text('Nenhum aviso no momento.'))
          : RefreshIndicator(
              onRefresh: _carregar,
              child: ListView.builder(
                itemCount: _itens.length,
                itemBuilder: (_, index) {
                  final item = _itens[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        item.foiReagendado ? Icons.event_repeat : Icons.event,
                      ),
                    ),
                    title: Text(
                      item.foiReagendado
                          ? 'Agendamento reagendado: ${item.clienteNome ?? 'Cliente'}'
                          : '${item.statusLabel}: ${item.clienteNome ?? 'Cliente'}',
                    ),
                    subtitle: Text(
                      '${item.servicoNome ?? 'Serviço'} • '
                      '${item.foiReagendado ? 'Nova data e horário: ' : ''}'
                      '${DateFormat('dd/MM/yyyy HH:mm').format(item.dataHoraInicio.toLocal())}',
                    ),
                  );
                },
              ),
            ),
    );
  }
}
