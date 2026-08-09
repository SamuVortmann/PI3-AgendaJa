import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/agendamento.dart';

class DetalhesClientePage extends StatelessWidget {
  final Agendamento cliente;
  final List<Agendamento> historico;

  const DetalhesClientePage({
    super.key,
    required this.cliente,
    required this.historico,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111934),
        foregroundColor: Colors.white,
        title: const Text('Detalhes do cliente'),
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
            const CircleAvatar(radius: 48, child: Icon(Icons.person, size: 48)),
            const SizedBox(height: 16),
            Text(
              cliente.clienteNome ?? 'Cliente',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (cliente.clienteEmail != null)
              Text(cliente.clienteEmail!, textAlign: TextAlign.center),
            if (cliente.clienteTelefone != null)
              Text(cliente.clienteTelefone!, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            const Text(
              'Histórico de agendamentos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (historico.isEmpty)
              const Text('Nenhum agendamento encontrado.')
            else
              ...historico.map(_itemHistorico),
          ],
        ),
      ),
    );
  }

  Widget _itemHistorico(Agendamento item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(item.servicoNome ?? 'Serviço'),
        subtitle: Text(
          '${DateFormat('dd/MM/yyyy HH:mm').format(item.dataHoraInicio.toLocal())}\n${item.profissionalNome ?? 'Profissional'}',
        ),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.preco == null ? '' : 'R\$ ${item.preco!.toStringAsFixed(2)}',
            ),
            Text(item.statusLabel, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
