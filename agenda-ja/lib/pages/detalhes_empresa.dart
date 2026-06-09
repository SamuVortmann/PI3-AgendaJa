import 'package:flutter/material.dart';

class AgendamentoEmpresaDetalhesPage extends StatefulWidget {
  const AgendamentoEmpresaDetalhesPage({super.key});

  @override
  State<AgendamentoEmpresaDetalhesPage> createState() => _AgendamentoEmpresaDetalhesPageState();
}

class _AgendamentoEmpresaDetalhesPageState extends State<AgendamentoEmpresaDetalhesPage> {
  int diaSelecionado = 24;
  String? horarioSelecionado;

  final List<String> horariosDisponiveis = [
    '09:00', '10:00', '11:00', '13:00', '14:00', '15:00', '16:00', '17:00'
  ];

  final List<String> horariosOcupados = ['10:00', '11:00', '15:00'];

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
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
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
                  const SizedBox(width: 48), // Espaço para equilibrar a logo
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
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Endereço:\nRua Leonidas Favero, 261 – Loja 02\nBairro Jardim, Concórdia',
                              style: TextStyle(color: Colors.white70, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'CEP: 89703-024',
                              style: TextStyle(color: Colors.white70, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Telefone:\n(49) 99138-8396',
                              style: TextStyle(color: Colors.white70, fontSize: 15),
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
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.chevron_left),
                                SizedBox(width: 20),
                                Text('MAIO 2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                SizedBox(width: 20),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                            const SizedBox(height: 15),
                            // Dias da semana
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const ['D', 'S', 'T', 'Q', 'Q', 'S', 'S']
                                  .map((d) => Text(d, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))
                                  .toList(),
                            ),
                            const SizedBox(height: 10),
                            // Grade de dias (Simplificada para o exemplo)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                              itemCount: 31,
                              itemBuilder: (context, index) {
                                int dia = index + 1;
                                bool isSelecionado = dia == diaSelecionado;
                                return Center(
                                  child: GestureDetector(
                                    onTap: () => setState(() => diaSelecionado = dia),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
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
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // SELETOR DE HORÁRIOS MODERNO
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
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: horariosDisponiveis.map((h) {
                                bool isOcupado = horariosOcupados.contains(h);
                                bool isSelecionado = h == horarioSelecionado;
                                
                                return GestureDetector(
                                  onTap: isOcupado ? null : () => setState(() => horarioSelecionado = h),
                                  child: Container(
                                    width: 80,
                                    height: 35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isOcupado 
                                          ? Colors.red.withOpacity(0.7) 
                                          : (isSelecionado ? Colors.green : const Color(0xFFD9D9D9)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      h,
                                      style: TextStyle(
                                        color: isOcupado || isSelecionado ? Colors.white : Colors.black,
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
                                  onPressed: horarioSelecionado == null ? null : () {
                                    // Ação de agendar
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: const Text(
                                    'Escolher horário',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
