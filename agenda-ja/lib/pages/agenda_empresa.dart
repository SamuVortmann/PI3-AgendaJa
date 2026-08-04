import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import '../utils/date_utils.dart';

class AgendaPage extends StatefulWidget {
  final String nomeEmpresa;

  const AgendaPage({super.key, required this.nomeEmpresa});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DateTime _dataSelecionada = DateTime.now();
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
      final data = formatarDataIso(_dataSelecionada);
      final agendamentos = await AgendamentoService.instance.listarAdmin(
        dataInicio: data,
        dataFim: data,
      );
      if (mounted) setState(() => _agendamentos = agendamentos);
    } catch (e) {
      if (mounted) setState(() => _erro = e.toString());
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (data != null) {
      setState(() => _dataSelecionada = data);
      _carregar();
    }
  }

  Future<void> _alterarStatus(Agendamento agendamento, String status) async {
    try {
      await AgendamentoService.instance.atualizarAdmin(
        agendamento.id,
        status: status,
      );
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
        backgroundColor: const Color(0xFF1F2937),
        foregroundColor: Colors.white,
        title: Text('Agenda - ${widget.nomeEmpresa}'),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: InkWell(
                onTap: _selecionarData,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Color(0xFF2563EB),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(_dataSelecionada),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Icon(Icons.expand_more),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: _conteudo()),
          ],
        ),
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
            Text(_erro!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _carregar,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }
    if (_agendamentos.isEmpty)
      return const Center(child: Text('Nenhum agendamento nesta data.'));
    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        itemCount: _agendamentos.length,
        itemBuilder: (_, index) => _card(_agendamentos[index]),
      ),
    );
  }

  Widget _card(Agendamento agendamento) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            DateFormat('HH:mm').format(agendamento.dataHoraInicio.toLocal()),
          ),
        ),
        title: Text(agendamento.clienteNome ?? 'Cliente'),
        subtitle: Text(
          '${agendamento.servicoNome ?? 'Serviço'} • ${agendamento.profissionalNome ?? 'Profissional'}',
        ),
        trailing: PopupMenuButton<String>(
          initialValue: agendamento.status,
          onSelected: (status) => _alterarStatus(agendamento, status),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'pendente', child: Text('Pendente')),
            PopupMenuItem(value: 'confirmado', child: Text('Confirmado')),
            PopupMenuItem(value: 'cancelado', child: Text('Cancelado')),
          ],
          child: Chip(label: Text(agendamento.status)),
        ),
      ),
    );
  }
}
