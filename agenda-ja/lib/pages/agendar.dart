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
  final TextEditingController _buscaController = TextEditingController();
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

  List<Servico> get servicosFiltrados {
    final busca = _buscaController.text.toLowerCase();
    if (busca.isEmpty) return _servicos;
    return _servicos.where((s) {
      return s.nome.toLowerCase().contains(busca) ||
          (s.descricao?.toLowerCase().contains(busca) ?? false);
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset('assets/logo.png', width: 80,
                          errorBuilder: (_, __, ___) => const Icon(Icons.circle, color: Colors.white)),
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
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Escolha um serviço', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 16),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: TextField(
                          controller: _buscaController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: 'Buscar serviço...',
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: _carregando
                            ? const Center(child: CircularProgressIndicator())
                            : _erro != null
                                ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(_erro!, textAlign: TextAlign.center),
                                        const SizedBox(height: 12),
                                        ElevatedButton(onPressed: _carregar, child: const Text('Tentar novamente')),
                                      ],
                                    ),
                                  )
                                : servicosFiltrados.isEmpty
                                    ? const Center(child: Text('Nenhum serviço disponível.'))
                                    : ListView.builder(
                                        itemCount: servicosFiltrados.length,
                                        itemBuilder: (context, index) {
                                          final servico = servicosFiltrados[index];
                                          return Container(
                                            margin: const EdgeInsets.only(bottom: 15),
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF111934),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(servico.nome, style: const TextStyle(color: Colors.white, fontSize: 18)),
                                                if (servico.descricao != null) ...[
                                                  const SizedBox(height: 5),
                                                  Text(servico.descricao!, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                                ],
                                                const SizedBox(height: 5),
                                                Text(
                                                  '${servico.duracaoMinutos} min • R\$ ${servico.preco.toStringAsFixed(2)}',
                                                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                                                ),
                                                Align(
                                                  alignment: Alignment.bottomRight,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => AgendamentoEmpresaDetalhesPage(servico: servico),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text('Agendar', style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
