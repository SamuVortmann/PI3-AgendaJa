import 'package:flutter/material.dart';

class AgendarPage extends StatefulWidget {
  final String nomeEmpresa;

  const AgendarPage({super.key, required this.nomeEmpresa});

  @override
  State<AgendarPage> createState() => _AgendarPageState();
}

class _AgendarPageState extends State<AgendarPage> {
  final TextEditingController _buscaController = TextEditingController();
  String _filtroSelecionado = '';

  // LISTA DE EMPRESAS PRÉ-DEFINIDAS
  final List<Map<String, String>> todasEmpresas = [
    {
      'nome': 'Prado Concept Salão de Beleza',
      'endereco': 'Centro, Concórdia - SC',
      'categoria': 'Beleza',
    },
    {
      'nome': 'Salão Arte & Beleza',
      'endereco': 'Bairro Nazaré, Concórdia - SC',
      'categoria': 'Beleza',
    },
    {
      'nome': 'Clinica Tesser',
      'endereco': 'Centro, Concórdia - SC',
      'categoria': 'Saúde',
    },
    {
      'nome': 'Hospital São Francisco',
      'endereco': 'Centro, Concórdia - SC',
      'categoria': 'Saúde',
    },
    {
      'nome': 'Escola Aprender',
      'endereco': 'Bairro das Nações, Concórdia - SC',
      'categoria': 'Educação',
    },
    {
      'nome': 'JCS Estética',
      'endereco': 'Centro, Concórdia - SC',
      'categoria': 'Beleza',
    },
  ];

  List<Map<String, String>> get empresasFiltradas {
    return todasEmpresas.where((empresa) {
      final matchesBusca = empresa['nome']!.toLowerCase().contains(
        _buscaController.text.toLowerCase(),
      );
      final matchesFiltro =
          _filtroSelecionado.isEmpty ||
          empresa['categoria'] == _filtroSelecionado;
      return matchesBusca && matchesFiltro;
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
            // CABEÇALHO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png',
                        width: 80,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.circle, color: Colors.white),
                      ),
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
                          PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.tune,
                              size: 35,
                              color: Colors.black87,
                            ),
                            onSelected: (String value) {
                              setState(() => _filtroSelecionado = value);
                            },
                            itemBuilder: (BuildContext context) => [
                              _buildPopupItem('Beleza'),
                              _buildPopupItem('Saúde'),
                              _buildPopupItem('Educação'),
                              _buildPopupItem('Outros'),
                            ],
                          ),
                          const SizedBox(width: 5),
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
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (_filtroSelecionado.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Chip(
                              label: Text(
                                _filtroSelecionado,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              onDeleted: () =>
                                  setState(() => _filtroSelecionado = ''),
                              deleteIcon: const Icon(Icons.close, size: 18),
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // LISTA DE EMPRESAS
                      Expanded(
                        child: empresasFiltradas.isEmpty
                            ? const Center(
                                child: Text(
                                  'Nenhuma empresa encontrada.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              )
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          empresa['nome']!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          empresa['endereco']!,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/detalhes_empresa',
                                                arguments: empresa,
                                              );
                                            },
                                            child: const Text(
                                              'Detalhes',
                                              style: TextStyle(
                                                color: Colors.white54,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
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

  PopupMenuItem<String> _buildPopupItem(String valor) {
    return PopupMenuItem<String>(
      value: valor,
      child: Row(
        children: [
          if (_filtroSelecionado == valor)
            const Icon(Icons.check, size: 20, color: Color(0xFF111934)),
          const SizedBox(width: 10),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }
}

// No seu MaterialApp, garanta que a rota esteja registrada, por exemplo:
// routes: {
//   '/detalhes_empresa': (context) => const DetalhesEmpresaPage(),
// },
//
// Se a rota no seu projeto estiver cadastrada com barra, use '/detalhes_empresa'
// também no Navigator.pushNamed.
