import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import '../services/api_client.dart';
import 'agendar.dart';

class DetalhesAgendamentoPage extends StatelessWidget {
  final Agendamento agendamento;

  const DetalhesAgendamentoPage({super.key, required this.agendamento});

  Future<void> _cancelar(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar agendamento?'),
        content: const Text(
          'O cancelamento só é permitido com pelo menos 2 horas de antecedência.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar cancelamento'),
          ),
        ],
      ),
    );
    if (confirmar != true || !context.mounted) return;
    try {
      await AgendamentoService.instance.cancelar(agendamento.id);
      if (context.mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
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
        title: const Text('Detalhes'),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agendamento.servicoNome ?? 'Serviço',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'com ${agendamento.profissionalNome ?? 'Profissional'}',
                    ),
                    Text(agendamento.empresaNome ?? 'Empresa'),
                    const Divider(height: 28),
                    _item(
                      Icons.schedule,
                      DateFormat(
                        'dd/MM/yyyy HH:mm',
                      ).format(agendamento.dataHoraInicio.toLocal()),
                    ),
                    if (agendamento.duracaoMinutos != null)
                      _item(
                        Icons.timer_outlined,
                        '${agendamento.duracaoMinutos} minutos',
                      ),
                    if (agendamento.empresaEndereco != null)
                      _item(
                        Icons.location_on_outlined,
                        agendamento.empresaEndereco!,
                      ),
                    if (agendamento.preco != null)
                      _item(
                        Icons.payments_outlined,
                        'R\$ ${agendamento.preco!.toStringAsFixed(2)}',
                      ),
                    _item(Icons.info_outline, agendamento.statusLabel),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AgendarPage()),
              ),
              child: const Text('Fazer novo agendamento'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: agendamento.isCancelado
                  ? null
                  : () => _cancelar(context),
              child: const Text('Cancelar agendamento'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(child: Text(texto)),
        ],
      ),
    );
  }
}
