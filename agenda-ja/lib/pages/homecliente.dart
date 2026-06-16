import 'package:flutter/material.dart';
import 'menu.dart';
import 'agendar.dart'; 

class HomeClientePage extends StatefulWidget {
  final String nome;
  final String telefone;

  const HomeClientePage({
    super.key,
    required this.nome,
    required this.telefone,
  });

  @override
  State<HomeClientePage> createState() => _HomeClientePageState();
}

class _HomeClientePageState extends State<HomeClientePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int mesAtual = DateTime.now().month - 1;
  int? diaSelecionado; // Para marcar a bolinha azul
  String filtroSelecionado = 'Todos';

  final List<String> meses = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];

  final List<String> categoriasFiltro = ['Todos', 'Beleza', 'Saúde', 'Educação', 'Outros'];

  // Exemplo de dias com compromisso (para teste)
  final List<int> diasComCompromisso = [10, 27];

  int diasDoMes() {
    DateTime data = DateTime(2026, mesAtual + 2, 0);
    return data.day;
  }

  int primeiroDiaMes() {
    DateTime data = DateTime(2026, mesAtual + 1, 1);
    return data.weekday % 7;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF111934),
      drawer: MenuCliente(nome: widget.nome, telefone: widget.telefone),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    // NAVBAR
                    Container(
                      width: double.infinity,
                      height: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      color: const Color(0xFF111934),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                            icon: const Icon(Icons.menu, color: Colors.white, size: 34),
                          ),
                          Image.asset(
                            'assets/logo.png',
                            width: 100,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.white),
                          ),
                          const SizedBox(width: 34),
                        ],
                      ),
                    ),

                    // CONTEÚDO
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: constraints.maxHeight - 100),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(45)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Olá, ${widget.nome}!', style: const TextStyle(fontSize: 20, decoration: TextDecoration.underline)),
                            const SizedBox(height: 18),

                            // PESQUISA COM FILTRO
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(horizontal: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: const Color(0xFF111934)),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Row(
                                      children: [
                                        Expanded(child: TextField(decoration: InputDecoration(hintText: 'Buscar serviço...', border: InputBorder.none, hintStyle: TextStyle(fontSize: 14)))),
                                        Icon(Icons.search, color: Color(0xFF111934)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  height: 50, width: 50,
                                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFF111934)), borderRadius: BorderRadius.circular(14)),
                                  child: PopupMenuButton<String>(
                                    icon: const Icon(Icons.tune, color: Color(0xFF111934)),
                                    onSelected: (val) => setState(() => filtroSelecionado = val),
                                    itemBuilder: (ctx) => categoriasFiltro.map((cat) => PopupMenuItem(value: cat, child: Text(cat))).toList(),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),
                            SizedBox(
                              width: 120, height: 40,
                              child: ElevatedButton(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => AgendarPage(nomeEmpresa: widget.nome))),
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF111934), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text('+ Agendar', style: TextStyle(color: Colors.white, fontSize: 15)),
                              ),
                            ),
                            const SizedBox(height: 30),

                            const Text('Sua agenda', style: TextStyle(fontSize: 18)),
                            const SizedBox(height: 10),

                            // CALENDÁRIO
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFF06153D)), borderRadius: BorderRadius.circular(14)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(onPressed: () => setState(() { if (mesAtual > 0) mesAtual--; }), icon: const Icon(Icons.arrow_back_ios, size: 18)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                                        decoration: BoxDecoration(color: const Color(0xFF111934), borderRadius: BorderRadius.circular(4)),
                                        child: Text(meses[mesAtual], style: const TextStyle(color: Colors.white)),
                                      ),
                                      IconButton(onPressed: () => setState(() { if (mesAtual < 11) mesAtual++; }), icon: const Icon(Icons.arrow_forward_ios, size: 18)),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [Text('D'), Text('S'), Text('T'), Text('Q'), Text('Q'), Text('S'), Text('S')]),
                                  const SizedBox(height: 18),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: diasDoMes() + primeiroDiaMes(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                                    itemBuilder: (context, index) {
                                      int dia = index - primeiroDiaMes() + 1;
                                      if (index < primeiroDiaMes()) return const SizedBox();
                                      
                                      bool isSelecionado = diaSelecionado == dia;
                                      
                                      return GestureDetector(
                                        onTap: () => setState(() => diaSelecionado = dia),
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: isSelecionado ? const Color(0xFF111934) : Colors.transparent,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '$dia',
                                            style: TextStyle(
                                              color: isSelecionado ? Colors.white : Colors.black,
                                              fontWeight: isSelecionado ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 20),

                            // CAIXA DE COMPROMISSOS (DINÂMICA)
                            if (diaSelecionado != null)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF111934),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Compromissos do dia $diaSelecionado/${mesAtual + 1}:',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    if (diasComCompromisso.contains(diaSelecionado))
                                      const Text('• 14:30 - Prado Concept\n• 16:00 - Clínica Vida', style: TextStyle(color: Colors.white))
                                    else
                                      const Text('Sem compromissos para este dia.', style: TextStyle(color: Colors.white70)),
                                  ],
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
          },
        ),
      ),
    );
  }
}