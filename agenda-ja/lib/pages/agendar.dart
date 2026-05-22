import 'package:flutter/material.dart';

class AgendarPage extends StatefulWidget {
  const AgendarPage({super.key});

  @override
  State<AgendarPage> createState() => _AgendarPageState();
}

class _AgendarPageState extends State<AgendarPage> {
  final TextEditingController _searchController = TextEditingController();
  String filtroSelecionado = 'Todos';
  
  final List<Map<String, String>> todasEmpresas = []; 
  List<Map<String, String>> empresasFiltradas = [];
  bool mostrarResultados = false;

  void filtrarEmpresas(String query) {
    setState(() {
      if (query.isEmpty && filtroSelecionado == 'Todos') {
        mostrarResultados = false;
        empresasFiltradas = [];
      } else {
        mostrarResultados = true;
        empresasFiltradas = todasEmpresas.where((empresa) {
          final matchesQuery = empresa['nome']!.toLowerCase().contains(query.toLowerCase());
          final matchesFiltro = filtroSelecionado == 'Todos' || empresa['categoria'] == filtroSelecionado;
          return matchesQuery && matchesFiltro;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            // NAVBAR com Botão de Voltar e LOGO
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              color: const Color(0xFF111934),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png', // Substituído o texto pela logo
                        width: 110,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Mantém a logo centralizada
                ],
              ),
            ),

            // CONTEÚDO
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.tune, color: Colors.black, size: 30),
                            onSelected: (String value) {
                              setState(() {
                                filtroSelecionado = value;
                                filtrarEmpresas(_searchController.text);
                              });
                            },
                            itemBuilder: (BuildContext context) => [
                              'Todos', 'Beleza', 'Saúde', 'Educação', 'Outros'
                            ].map((String cat) => PopupMenuItem(
                              value: cat,
                              child: Text(cat),
                            )).toList(),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black, width: 0.8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: filtrarEmpresas,
                                      decoration: const InputDecoration(
                                        hintText: 'Buscar empresa ou serviço...',
                                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.search, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      Expanded(
                        child: mostrarResultados
                            ? (empresasFiltradas.isEmpty 
                                ? const Center(
                                    child: Text(
                                      'Nenhuma empresa cadastrada nesta categoria',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: empresasFiltradas.length,
                                    itemBuilder: (context, index) {
                                      final empresa = empresasFiltradas[index];
                                      return cardEmpresa(
                                        empresa['nome']!,
                                        empresa['endereco']!,
                                      );
                                    },
                                  ))
                            : const Center(
                                child: Text(
                                  'Pesquise ou filtre para encontrar serviços',
                                  style: TextStyle(color: Colors.grey),
                                ),
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

  Widget cardEmpresa(String nome, String endereco) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111934),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nome,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            endereco,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'Detalhes',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
