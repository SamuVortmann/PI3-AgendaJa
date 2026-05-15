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

  int mesAtual = 4;

  List meses = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];

  bool mostrarCompromisso = false;

  List<int> diasComCompromisso = [28];

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
                color: Color(0xFF06153D),
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

                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF06153D),
                      ),

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: const TextField(

                      decoration: InputDecoration(
                        hintText: 'Buscar serviço, empresa...',
                        border: InputBorder.none,

                        prefixIcon: Icon(Icons.search),

                        contentPadding: EdgeInsets.only(top: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // BOTÃO AGENDAR

                  SizedBox(
                    width: 110,
                    height: 40,

                    child: ElevatedButton(
                      onPressed: () {},

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06153D),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      child: const Text(
                        '+ Agendar',

                        style: TextStyle(
                          color: Colors.white,
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

                        // MÊS

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [

                            IconButton(
                              onPressed: () {

                                setState(() {

                                  if (mesAtual > 0) {
                                    mesAtual--;
                                  }
                                });
                              },

                              icon: const Icon(Icons.arrow_back_ios, size: 18),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 5,
                              ),

                              color: const Color(0xFF06153D),

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
                                });
                              },

                              icon: const Icon(Icons.arrow_forward_ios, size: 18),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // DIAS SEMANA

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

                        // DIAS

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),

                          itemCount: 30,

                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            childAspectRatio: 1.2,
                          ),

                          itemBuilder: (context, index) {

                            int dia = index + 1;

                            bool temCompromisso =
                            diasComCompromisso.contains(dia);

                            return GestureDetector(

                              onTap: () {

                                if (temCompromisso) {

                                  setState(() {
                                    mostrarCompromisso =
                                    !mostrarCompromisso;
                                  });
                                }
                              },

                              child: Center(
                                child: Container(
                                  width: 34,
                                  height: 34,

                                  decoration: BoxDecoration(
                                    color: temCompromisso
                                        ? const Color(0xFF06153D)
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
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // COMPROMISSOS

                        if (mostrarCompromisso)

                          Container(
                            width: double.infinity,

                            margin: const EdgeInsets.only(top: 12),

                            padding: const EdgeInsets.all(16),

                            decoration: BoxDecoration(
                              color: const Color(0xFF06153D),

                              borderRadius: BorderRadius.circular(14),
                            ),

                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                Text(
                                  'Compromissos:',

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),

                                SizedBox(height: 12),

                                Text(
                                  '15:30 - Clínica vida - Concórdia',

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),

                                SizedBox(height: 20),

                                Text(
                                  '18:00 - Salão bela vista - Irani',

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // AGENDAMENTOS DO MÊS

                  const Text(
                    'Agendamentos do mês',

                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    height: 90,

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