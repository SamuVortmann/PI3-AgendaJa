import 'package:flutter/material.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import '../services/api_client.dart';
import '../utils/date_utils.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  String _visao = 'dia';
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
      final ags = await AgendamentoService.instance.listarAdmin(visao: _visao);
      if (mounted) setState(() => _agendamentos = ags);
    } catch (_) {
      if (mounted) setState(() => _agendamentos = []);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _atualizarStatus(Agendamento ag, String status) async {
    try {
      await AgendamentoService.instance.atualizarAdmin(ag.id, status: status);
      _carregar();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  void _mostrarDetalhes(Agendamento ag) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          color: Color(0xFFF3F3F3),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ag.clienteNome ?? 'Cliente', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Serviço: ${ag.servicoNome}'),
            Text('Profissional: ${ag.profissionalNome}'),
            Text('Data: ${formatarData(ag.dataHoraInicio)} • ${formatarHora(ag.dataHoraInicio)}'),
            Text('Status: ${statusLabel(ag.status)}'),
            Text('Tel: ${ag.clienteTelefone ?? "-"}'),
            const SizedBox(height: 20),
            if (ag.status != 'confirmado' && !ag.isCancelado)
              _botaoModal('Confirmar', Colors.green, () {
                Navigator.pop(ctx);
                _atualizarStatus(ag, 'confirmado');
              }),
            if (!ag.isCancelado) ...[
              const SizedBox(height: 8),
              _botaoModal('Cancelar', Colors.red, () {
                Navigator.pop(ctx);
                _atualizarStatus(ag, 'cancelado');
              }),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 80,
              color: const Color(0xFF111934),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
                  const Expanded(child: Center(child: Text('Agenda Admin', style: TextStyle(color: Colors.white, fontSize: 18)))),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: const Text('Hoje'),
                            selected: _visao == 'dia',
                            onSelected: (_) {
                              setState(() => _visao = 'dia');
                              _carregar();
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Semana'),
                            selected: _visao == 'semana',
                            onSelected: (_) {
                              setState(() => _visao = 'semana');
                              _carregar();
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _carregando
                          ? const Center(child: CircularProgressIndicator())
                          : RefreshIndicator(
                              onRefresh: _carregar,
                              child: _agendamentos.isEmpty
                                  ? const ListTile(title: Text('Nenhum agendamento neste período'))
                                  : ListView.builder(
                                      itemCount: _agendamentos.length,
                                      itemBuilder: (_, i) {
                                        final ag = _agendamentos[i];
                                        return ListTile(
                                          title: Text('${ag.clienteNome} - ${ag.servicoNome}'),
                                          subtitle: Text('${formatarData(ag.dataHoraInicio)} ${formatarHora(ag.dataHoraInicio)}'),
                                          trailing: Text(statusLabel(ag.status)),
                                          onTap: () => _mostrarDetalhes(ag),
                                        );
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
    );
  }

  Widget _botaoModal(String texto, Color cor, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(backgroundColor: cor),
        child: Text(texto, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
