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

  // SEM AGENDAMENTOS

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

  // DESCOBRE O PRIMEIRO DIA DA SEMANA

  int primeiroDiaMes() {

    DateTime data = DateTime(
      2026,
      mesAtual + 1,
      1,
    );

    return data.weekday % 7;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      body: SingleChildScrollView(

        child: Column(
          children: [

            // NAVBAR

            Container(
              width: double.infinity,
              height: 120,

              padding: const EdgeInsets.only(
                top: 35,
                left: 18,
                right: 18,
              ),

              decoration: const BoxDecoration(
                color: Color(0xFF111934),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45),
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 34,
                  ),

                  Image.asset(
                    'assets/logo.png',
                    width: 80,
                  ),

                  const SizedBox(width: 34),
                ],
              ),
            ),

            Padding(
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

                    padding: const EdgeInsets.symmetric(horizontal: 14),

                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF111934),
                      ),

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

                        Icon(
                          Icons.search,
                          color: Color(0xFF111934),
                        )
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
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Sua agenda',

                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // CALENDÁRIO

                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      border: Border.all(
                        color: const Color(0xFF06153D),
                      ),

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: Column(
                      children: [

                        // TROCA DE MÊS

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [

                            IconButton(
                              onPressed: () {

                                setState(() {

                                  if (mesAtual > 0) {
                                    mesAtual--;
                                  }

                                  mostrarCompromissos = false;
                                });
                              },

                              icon: const Icon(Icons.arrow_back_ios, size: 18),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 5,
                              ),

                              decoration: BoxDecoration(
                                color: const Color(0xFF111934),
                                borderRadius: BorderRadius.circular(4),
                              ),

                              child: Text(
                                meses[mesAtual],

                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            IconButton(
                              onPressed: () {

                                setState(() {

                                  if (mesAtual < 11) {
                                    mesAtual++;
                                  }

                                  mostrarCompromissos = false;
                                });
                              },

                              icon: const Icon(Icons.arrow_forward_ios, size: 18),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // DIAS DA SEMANA

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,

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

                        // GRID DO CALENDÁRIO

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),

                          itemCount:
                          diasDoMes() + primeiroDiaMes(),

                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            childAspectRatio: 1,
                          ),

                          itemBuilder: (context, index) {

                            // ESPAÇOS VAZIOS

                            if (index < primeiroDiaMes()) {
                              return const SizedBox();
                            }

                            int dia =
                                index - primeiroDiaMes() + 1;

                            // NUNCA COMEÇA AZUL

                            bool temCompromisso =
                                diasComCompromisso.contains(dia) &&
                                diasComCompromisso.isNotEmpty;

                            return GestureDetector(

                              onTap: () {

                                if (temCompromisso) {

                                  setState(() {
                                    mostrarCompromissos =
                                    !mostrarCompromissos;
                                  });
                                }
                              },

                              child: Center(
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
                              ),
                            );
                          },
                        ),

                        // COMPROMISSOS

                        if (mostrarCompromissos)

                          Container(
                            width: double.infinity,

                            margin: const EdgeInsets.only(top: 15),

                            padding: const EdgeInsets.all(16),

                            decoration: BoxDecoration(
                              color: const Color(0xFF06153D),
                              borderRadius: BorderRadius.circular(14),
                            ),

                            child: const Text(
                              'Compromissos do dia',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // AGENDAMENTOS

                  const Text(
                    'Agendamentos do mês',

                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

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
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}