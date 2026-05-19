import 'package:flutter/material.dart';

class CadastroEmpresaPage extends StatefulWidget {
  const CadastroEmpresaPage({super.key});

  @override
  State<CadastroEmpresaPage> createState() => _CadastroEmpresaPageState();
}

class _CadastroEmpresaPageState extends State<CadastroEmpresaPage> {
  String? tipoServico;

  Map<String, bool> diasSelecionados = {
    'Segunda': true,
    'Terça': false,
    'Quarta': true,
    'Quinta': false,
    'Sexta': false,
    'Sábado': false,
    'Domingo': false,
  };

  Map<String, Map<String, String>> horarios = {
    'Segunda': {'inicio': '12:00', 'fim': '13:00'},
    'Terça': {'inicio': '08:30', 'fim': '18:00'},
    'Quarta': {'inicio': '08:30', 'fim': '18:00'},
    'Quinta': {'inicio': '08:30', 'fim': '18:00'},
    'Sexta': {'inicio': '08:30', 'fim': '18:00'},
    'Sábado': {'inicio': '', 'fim': ''},
    'Domingo': {'inicio': '', 'fim': ''},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            // TOPO
            Container(
              width: double.infinity,
              height: 90,
              alignment: Alignment.center,
              color: const Color(0xFF111934),
              child: const Text(
                'Empresa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // CONTEÚDO
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // CARD
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TIPO SERVIÇO
                            const Text(
                              'Tipo de serviço',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F4F4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButton<String>(
                                value: tipoServico,
                                isExpanded: true,
                                underline: const SizedBox(),
                                hint: const Text(
                                  'seu tipo de serviço',
                                  style: TextStyle(fontSize: 12),
                                ),
                                items: ['Beleza', 'Saúde', 'Educação', 'Outros']
                                    .map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    tipoServico = value;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(height: 18),

                            // ENDEREÇO
                            const Text(
                              'Endereço:',
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F4F4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: 'endereço do seu comércio',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            // TITULOS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Dia de funcionamento',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Horários',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // DIAS
                            ...diasSelecionados.keys.map((dia) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Checkbox(
                                        value: diasSelecionados[dia],
                                        onChanged: (value) {
                                          setState(() {
                                            diasSelecionados[dia] = value!;
                                          });
                                        },
                                        activeColor: const Color(0xFF111934),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 90,
                                      child: Text(
                                        dia,
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    if (diasSelecionados[dia]!)
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            horarioBox(
                                              horarios[dia]!['inicio']!,
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6,
                                              ),
                                              child: Text('-'),
                                            ),
                                            horarioBox(
                                              horarios[dia]!['fim']!,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // BOTÃO
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'CONTINUAR ➜',
                            style: TextStyle(
                              color: Color(0xFF111934),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
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

  Widget horarioBox(String texto) {
    return Container(
      width: 58,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }
}
