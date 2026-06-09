import 'package:flutter/material.dart';
import 'confirmacao_agendamento.dart';

class AgendamentoEmpresaDetalhesPage extends StatefulWidget {
  const AgendamentoEmpresaDetalhesPage({super.key});

  @override
  State<AgendamentoEmpresaDetalhesPage> createState() =>
      _AgendamentoEmpresaDetalhesPageState();
}

class _AgendamentoEmpresaDetalhesPageState
    extends State<AgendamentoEmpresaDetalhesPage> {
  int diaSelecionado = DateTime.now().day;
  String? horarioSelecionado;

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

  final List<String> horariosDisponiveis = [
    '09:00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ];

  final List<String> horariosOcupados = ['10:00', '11:00', '15:00'];

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
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            // NAVBAR
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              color: const Color(0xFF111934),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png',
                        width: 100,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image, color: Colors.white),
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(45)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      // CARD DA EMPRESA
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111934),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Prado Concept Salão de Beleza',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Endereço:\nRua Leonidas Favero, 261 – Loja 02\nBairro Jardim, Concórdia',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'CEP: 89703-024',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Telefone:\n(49) 99138-8396',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // CALENDÁRIO
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
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
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    size: 18,
                                  ),
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
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (mesAtual < 11) mesAtual++;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

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

                            const SizedBox(height: 10),

                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: diasDoMes() + primeiroDiaMes(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                    childAspectRatio: 1,
                                  ),
                              itemBuilder: (context, index) {
                                if (index < primeiroDiaMes()) {
                                  return const SizedBox();
                                }

                                int dia = index - primeiroDiaMes() + 1;

                                bool isSelecionado = dia == diaSelecionado;

                                return Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        diaSelecionado = dia;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isSelecionado
                                            ? const Color(0xFF111934)
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '$dia',
                                        style: TextStyle(
                                          color: isSelecionado
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: isSelecionado
                                              ? FontWeight.bold
                                              : FontWeight.normal,
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

                      const SizedBox(height: 25),

                      // HORÁRIOS
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111934),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'HORÁRIOS DISPONÍVEIS:',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: horariosDisponiveis.map((h) {
                                bool isOcupado = horariosOcupados.contains(h);
                                bool isSelecionado = h == horarioSelecionado;

                                return GestureDetector(
                                  onTap: isOcupado
                                      ? null
                                      : () {
                                          setState(() {
                                            horarioSelecionado = h;
                                          });
                                        },
                                  child: Container(
                                    width: 80,
                                    height: 35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isOcupado
                                          ? Colors.red.withOpacity(0.7)
                                          : (isSelecionado
                                                ? Colors.green
                                                : const Color(0xFFD9D9D9)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      h,
                                      style: TextStyle(
                                        color: isOcupado || isSelecionado
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 25),
                            Center(
                              child: SizedBox(
                                width: 200,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: horarioSelecionado == null
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ConfirmacaoAgendamentoPage(),
                                            ),
                                          );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Escolher horário',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
