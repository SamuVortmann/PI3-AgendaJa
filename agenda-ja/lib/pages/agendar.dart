import 'package:flutter/material.dart';

class AgendarPage extends StatefulWidget {
  const AgendarPage({super.key});

  @override
  State<AgendarPage> createState() => _AgendarPageState();
}

class _AgendarPageState extends State<AgendarPage> {
  final TextEditingController _buscaController = TextEditingController();
  String _filtroSelecionado = '';

  // LISTA DE EMPRESAS PRÉ-DEFINIDAS PARA TESTE
  final List<Map<String, String>> todasEmpresas = [
    {
      'nome': 'Prado Concept Salão de Beleza',
      'endereco': 'Centro, Concórdia - SC',
      'categoria': 'Beleza'
    },
    {
      'nome': 'Salão Arte & Beleza',
      'endereco': 'Bairro Nazaré, Concórdia - SC',
      'categoria': 'Beleza'
    },
    {
      'nome': 'Clinica Tesser',
      'endereco': 'Centro, Concórdia - SC',
      'categoria': 'Saúde'
    },
    {
      'nome': 'Hospital São Francisco',
      'endereco': 'Centro, Concórdia - SC',
      'categoria': 'Saúde'
    },
    {
      'nome': 'Escola Aprender',
      'endereco': 'Bairro das Nações, Concórdia - SC',
      'categoria': 'Educação'
    },
    {
      'nome': 'JCS Estética',
      'endereco': 'Centro, Concórdia - SC',
      'categoria': 'Beleza'
    },
  ];

  List<Map<String, String>> get empresasFiltradas {
    return todasEmpresas.where((empresa) {
      final matchesBusca = empresa['nome']!
          .toLowerCase()
          .contains(_buscaController.text.toLowerCase());
      final matchesFiltro =
          _filtroSelecionado.isEmpty || empresa['categoria'] == _filtroSelecionado;
      return matchesBusca && matchesFiltro;
    }).toList();
  }

  void _abrirFiltro() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111934),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Filtrar por Categoria',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _itemFiltro('Beleza'),
              _itemFiltro('Saúde'),
              _itemFiltro('Educação'),
              _itemFiltro('Outros'),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() => _filtroSelecionado = '');
                  Navigator.pop(context);
                },
                child: const Text('Limpar Filtro', style: TextStyle(color: Colors.redAccent)),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _itemFiltro(String categoria) {
    return ListTile(
      title: Text(categoria, style: const TextStyle(color: Colors.white)),
      trailing: _filtroSelecionado == categoria
          ? const Icon(Icons.check, color: Colors.white)
          : null,
      onTap: () {
        setState(() => _filtroSelecionado = categoria);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO COM LOGO E VOLTAR
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
                      child: Image.asset('assets/logo.png', width: 80, errorBuilder: (context, error, stackTrace) => const Icon(Icons.circle, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // CONTEÚDO
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
                    children: [
                      // BARRA DE PESQUISA E FILTRO
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.filter_list, size: 35),
                            onPressed: _abrirFiltro,
                          ),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: TextField(
                                controller: _buscaController,
                                onChanged: (value) => setState(() {}),
                                decoration: const InputDecoration(
                                  hintText: 'Buscar empresa ou serviço...',
                                  prefixIcon: Icon(Icons.search),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      if (_filtroSelecionado.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Chip(
                            label: Text(_filtroSelecionado),
                            onDeleted: () => setState(() => _filtroSelecionado = ''),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // LISTA DE EMPRESAS
                      Expanded(
                        child: empresasFiltradas.isEmpty
                            ? const Center(child: Text('Nenhuma empresa encontrada.'))
                            : ListView.builder(
                                itemCount: empresasFiltradas.length,
                                itemBuilder: (context, index) {
                                  final empresa = empresasFiltradas[index];
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
                                        Text(empresa['nome']!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 5),
                                        Text(empresa['endereco']!, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: TextButton(
                                            onPressed: () {},
                                            child: const Text('Detalhes', style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic)),
                                          ),
                                        )
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
