import 'package:flutter/material.dart';

import '../models/servico.dart';
import '../services/servico_service.dart';
import 'detalhes_empresa.dart';

class AgendarPage extends StatefulWidget {
  const AgendarPage({super.key});

  @override
  State<AgendarPage> createState() => _AgendarPageState();
}

class _AgendarPageState extends State<AgendarPage> {
  final _buscaController = TextEditingController();
  List<Servico> _servicos = [];
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
      final servicos = await ServicoService.instance.listarAtivos();
      if (mounted) setState(() => _servicos = servicos);
    } catch (e) {
      if (mounted) setState(() => _erro = e.toString());
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  List<Servico> get _filtrados {
    final busca = _buscaController.text.trim().toLowerCase();
    if (busca.isEmpty) return _servicos;
    return _servicos.where((servico) {
      return servico.nome.toLowerCase().contains(busca) ||
          (servico.descricao?.toLowerCase().contains(busca) ?? false) ||
          (servico.empresaNome?.toLowerCase().contains(busca) ?? false);
    }).toList();
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
        title: const Text('Escolha um serviço'),
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
                hintText: 'Buscar serviço ou empresa',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
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
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _carregar,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }
    if (_filtrados.isEmpty)
      return const Center(child: Text('Nenhum serviço disponível.'));
    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        itemCount: _filtrados.length,
        itemBuilder: (_, index) => _card(_filtrados[index]),
      ),
    );
  }

  Widget _card(Servico servico) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(child: Icon(Icons.content_cut)),
        title: Text(
          servico.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${servico.empresaNome ?? 'Empresa'}\n${servico.duracaoMinutos} min • R\$ ${servico.preco.toStringAsFixed(2)}',
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AgendamentoEmpresaDetalhesPage(servico: servico),
          ),
        ),
      ),
    );
  }
}
