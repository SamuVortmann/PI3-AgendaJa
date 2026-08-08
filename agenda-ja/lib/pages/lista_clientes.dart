import 'package:flutter/material.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
// IMPORTANTE: Certifique-se de que o caminho do import está correto para o seu projeto
import 'detalhes_clientes.dart'; 

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

  // DADOS ESTÁTICOS CONFORME O WIREFRAME
  final List<Map<String, String>> _clientesEstaticos = [
    {'nome': 'Maria Silva', 'telefone': '(49) 90000-1111'},
    {'nome': 'João Pereira', 'telefone': '(49) 90000-2222'},
    {'nome': 'Ana Costa', 'telefone': '(49) 90000-3333'},
    {'nome': 'Bia Lima', 'telefone': '(49) 90000-4444'},
  ];

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
      final agendamentos = await AgendamentoService.instance.listarAdmin(visao: 'todos');
      if (mounted) setState(() => _agendamentos = agendamentos);
    } catch (e) {
      if (mounted) setState(() => _erro = e.toString());
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  List<dynamic> get _listaExibicao {
    final busca = _buscaController.text.trim().toLowerCase();
    
    // Processa clientes do banco
    final unicos = <int, Agendamento>{};
    for (final ag in _agendamentos) {
      unicos[ag.clienteId] = ag;
    }
    
    List<dynamic> resultado = [];
    
    // Adiciona estáticos filtrados
    for (var c in _clientesEstaticos) {
      if (busca.isEmpty || c['nome']!.toLowerCase().contains(busca)) {
        resultado.add(c);
      }
    }
    
    // Adiciona dinâmicos filtrados
    for (var ag in unicos.values) {
      if (busca.isEmpty || (ag.clienteNome?.toLowerCase().contains(busca) ?? false)) {
        if (!_clientesEstaticos.any((e) => e['nome'] == ag.clienteNome)) {
          resultado.add(ag);
        }
      }
    }

    return resultado;
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
            // CABEÇALHO AZUL COM BOTÃO VOLTAR
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              color: const Color(0xFF111934),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context), 
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24)
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Clientes',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(45)),
                ),
                child: Column(
                  children: [
                    // BARRA DE BUSCA
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 30, 25, 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          controller: _buscaController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.search, color: Colors.grey),
                            hintText: 'Buscar cliente',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    
                    Expanded(
                      child: _carregando && _agendamentos.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : RefreshIndicator(
                              onRefresh: _carregar,
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                itemCount: _listaExibicao.length,
                                itemBuilder: (context, index) {
                                  final item = _listaExibicao[index];
                                  String nome = '';
                                  String telefone = '';
                                  
                                  if (item is Map) {
                                    nome = item['nome']!;
                                    telefone = item['telefone']!;
                                  } else if (item is Agendamento) {
                                    nome = item.clienteNome ?? 'Cliente';
                                    telefone = item.clienteTelefone ?? 'Sem telefone';
                                  }

                                  return _buildClienteCard(nome, telefone, item);
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

  Widget _buildClienteCard(String nome, String telefone, dynamic originalItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        onTap: () {
          // NAVEGAÇÃO ATIVADA PARA DETALHES
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetalhesClientePage(nomeCliente: nome),
            ),
          );
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade100,
          child: Icon(Icons.person, color: Colors.grey.shade400),
        ),
        title: Text(
          nome,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF111934)),
        ),
        subtitle: Text(
          telefone,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        ),
        trailing: const Icon(Icons.arrow_back_ios, size: 14, color: Colors.grey),
      ),
    );
  }
}
