import 'package:flutter/material.dart';

class HomeClientePage extends StatefulWidget {
  final String nome;

  const HomeClientePage({
    super.key,
    required this.nome,
  });

  @override
  State<HomeClientePage> createState() => _HomeClientePageState();
}

class _HomeClientePageState extends State<HomeClientePage> {
  int mesAtual = DateTime.now().month - 1;

  final List<String> meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  final List<int> diasComCompromisso = [];
  bool mostrarCompromissos = false;

  int diasDoMes() {
    switch (mesAtual + 1) {
      case 2:
        return 28;
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      default:
        return 31;
    }
  }

  int primeiroDiaMes() {
    DateTime data = DateTime(2026, mesAtual + 1, 1);
    return data.weekday % 7;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934), // Fundo azul escuro
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    // NAVBAR (Fundo Azul)
                    Container(
                      width: double.infinity,
                      height: 100, // Altura fixa para a navbar
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      color: const Color(0xFF111934),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.menu, color: Colors.white, size: 34),
                          // Caso a imagem não carregue no seu ambiente de teste, use um Placeholder ou verifique o caminho
                          Image.asset('assets/logo.png',
                              width: 80,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image, color: Colors.white)),
                          const SizedBox(width: 34),
                        ],
                      ),
                    ),

                    // CONTEÚDO (Fundo Cinza)
                    // Usamos um Container que se expande para ocupar no mínimo o resto da tela
                    Container(
                      width: double.infinity,
                      // Aqui garantimos que ele tenha pelo menos a altura da tela menos a navbar
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 100,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Olá, ${widget.nome}!',
                              style: const TextStyle(
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(height: 18),

                            // PESQUISA
                            Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFF111934)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Buscar serviço, empresa...',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.search, color: Color(0xFF111934))
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),

                            // BOTÃO AGENDAR
                            SizedBox(
                              width: 120,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF111934),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  '+ Agendar',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            const Text('Sua agenda',
                                style: TextStyle(fontSize: 18)),
                            const SizedBox(height: 10),

                            // CALENDÁRIO
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: const Color(0xFF06153D)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (mesAtual > 0) mesAtual--;
                                            mostrarCompromissos = false;
                                          });
                                        },
                                        icon: const Icon(Icons.arrow_back_ios,
                                            size: 18),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF111934),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          meses[mesAtual],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (mesAtual < 11) mesAtual++;
                                            mostrarCompromissos = false;
                                          });
                                        },
                                        icon: const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('D'),
                                      Text('S'),
                                      Text('T'),
                                      Text('Q'),
                                      Text('Q'),
                                      Text('S'),
                                      Text('S'),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: diasDoMes() + primeiroDiaMes(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 7,
                                      childAspectRatio: 1,
                                    ),
                                    itemBuilder: (context, index) {
                                      if (index < primeiroDiaMes())
                                        return const SizedBox();
                                      int dia = index - primeiroDiaMes() + 1;
                                      bool temCompromisso =
                                          diasComCompromisso.contains(dia) &&
                                              diasComCompromisso.isNotEmpty;
                                      return Center(
                                        child: Container(
                                          width: 34,
                                          height: 34,
                                          decoration: BoxDecoration(
                                            color: temCompromisso
                                                ? const Color(0xFF111934)
                                                : Colors.transparent,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$dia',
                                              style: TextStyle(
                                                color: temCompromisso
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text('Agendamentos do mês',
                                style: TextStyle(fontSize: 18)),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              height: 100,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Sem agendamentos',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40), // Espaço extra no final
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
