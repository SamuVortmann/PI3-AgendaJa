import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';

class ListaClientesPage extends StatefulWidget {
  const ListaClientesPage({super.key});

  @override
  State<ListaClientesPage> createState() => _ListaClientesPageState();
}

class _ListaClientesPageState extends State<ListaClientesPage> {
  final TextEditingController _buscaController = TextEditingController();
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
      final agendamentos = await AgendamentoService.instance.listarAdmin(
        visao: 'todos',
      );
      if (mounted) setState(() => _agendamentos = agendamentos);
    } catch (e) {
      if (mounted) setState(() => _erro = e.toString());
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  List<Agendamento> get _clientes {
    final unicos = <int, Agendamento>{};
    for (final agendamento in _agendamentos) {
      unicos[agendamento.clienteId] = agendamento;
    }
    final busca = _buscaController.text.trim().toLowerCase();
    final clientes = unicos.values.where((cliente) {
      return busca.isEmpty ||
          (cliente.clienteNome?.toLowerCase().contains(busca) ?? false) ||
          (cliente.clienteTelefone?.contains(busca) ?? false);
    }).toList();
    clientes.sort(
      (a, b) => (a.clienteNome ?? '').compareTo(b.clienteNome ?? ''),
    );
    return clientes;
  }

  void _mostrarDetalhes(Agendamento cliente) {
    final historico =
        _agendamentos.where((a) => a.clienteId == cliente.clienteId).toList()
          ..sort((a, b) => b.dataHoraInicio.compareTo(a.dataHoraInicio));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cliente.clienteNome ?? 'Cliente',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (cliente.clienteTelefone != null)
                Text(cliente.clienteTelefone!),
              const SizedBox(height: 20),
              const Text(
                'Histórico',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: historico.length,
                  itemBuilder: (_, index) {
                    final item = historico[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(item.servicoNome ?? 'Serviço'),
                      subtitle: Text(
                        DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(item.dataHoraInicio.toLocal()),
                      ),
                      trailing: Chip(label: Text(item.status)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111934),
        foregroundColor: Colors.white,
        title: const Text('Clientes'),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF3F3F3),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
        child: Column(
          children: [
            TextField(
              controller: _buscaController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Pesquise seus clientes...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
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
            ElevatedButton(
              onPressed: _carregar,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }
    if (_clientes.isEmpty)
      return const Center(child: Text('Nenhum cliente encontrado.'));
    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        itemCount: _clientes.length,
        itemBuilder: (_, index) {
          final cliente = _clientes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(cliente.clienteNome ?? 'Cliente'),
              subtitle: Text(cliente.clienteTelefone ?? 'Sem telefone'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _mostrarDetalhes(cliente),
            ),
          );
        },
      ),
    );
  }
}
