import 'package:flutter/material.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import 'detalhes_clientes.dart';

class ListaClientesPage extends StatefulWidget {
  const ListaClientesPage({super.key});

  @override
  State<ListaClientesPage> createState() => _ListaClientesPageState();
}

class _ListaClientesPageState extends State<ListaClientesPage> {
  final _buscaController = TextEditingController();
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
    for (final item in _agendamentos) {
      unicos[item.clienteId] = item;
    }
    final busca = _buscaController.text.trim().toLowerCase();
    final resultado = unicos.values.where((cliente) {
      return busca.isEmpty ||
          (cliente.clienteNome?.toLowerCase().contains(busca) ?? false) ||
          (cliente.clienteEmail?.toLowerCase().contains(busca) ?? false) ||
          (cliente.clienteTelefone?.contains(busca) ?? false);
    }).toList();
    resultado.sort(
      (a, b) => (a.clienteNome ?? '').compareTo(b.clienteNome ?? ''),
    );
    return resultado;
  }

  List<Agendamento> _historico(int clienteId) {
    final itens = _agendamentos
        .where((item) => item.clienteId == clienteId)
        .toList();
    itens.sort((a, b) => b.dataHoraInicio.compareTo(a.dataHoraInicio));
    return itens;
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
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
        child: Column(
          children: [
            TextField(
              controller: _buscaController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar cliente',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
              subtitle: Text(
                cliente.clienteTelefone ??
                    cliente.clienteEmail ??
                    'Sem contato',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetalhesClientePage(
                    cliente: cliente,
                    historico: _historico(cliente.clienteId),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
