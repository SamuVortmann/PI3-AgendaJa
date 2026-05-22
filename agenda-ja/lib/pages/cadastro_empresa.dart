import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CadastroEmpresaPage extends StatefulWidget {
  const CadastroEmpresaPage({super.key});

  @override
  State<CadastroEmpresaPage> createState() => _CadastroEmpresaPageState();
}

class _CadastroEmpresaPageState extends State<CadastroEmpresaPage> {
  String? tipoServico;

  Map<String, bool> diasSelecionados = {
    'Segunda': false,
    'Terça': false,
    'Quarta': false,
    'Quinta': false,
    'Sexta': false,
    'Sábado': false,
    'Domingo': false,
  };

  Map<String, Map<String, TextEditingController>> horariosControllers = {};

  @override
  void initState() {
    super.initState();
    diasSelecionados.keys.forEach((dia) {
      horariosControllers[dia] = {
        'inicio': TextEditingController(text: ''),
        'fim': TextEditingController(text: ''),
      };
    });
  }

  @override
  void dispose() {
    horariosControllers.values.forEach((controllers) {
      controllers['inicio']?.dispose();
      controllers['fim']?.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            // TOPO (Padronizado com CadastroPage)
            Container(
              width: double.infinity,
              height: 120, // Aumentado para 120 para igualar ao CadastroPage
              color: const Color(0xFF111934),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Empresa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30, // Aumentado para 30 para igualar ao CadastroPage
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
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
                    topLeft: Radius.circular(60), // Aumentado para 60 para igualar ao CadastroPage
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
                                fontSize: 18, // Aumentado para 16 para padronizar
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE0E0E0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: tipoServico,
                                  isExpanded: true,
                                  hint: const Text(
                                    'seu tipo de serviço',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                  items: ['Beleza', 'Saúde', 'Educação', 'Outros']
                                      .map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value, style: const TextStyle(color: Colors.black87)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      tipoServico = value;
                                    });
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // ENDEREÇO
                            const Text(
                              'Endereço:',
                              style: TextStyle(
                                fontSize: 18, // Aumentado para 16
                              ),
                            ),

                            const SizedBox(height: 8),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F4F4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: 'endereço do seu comércio',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
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
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Horários',
                                  style: TextStyle(fontSize: 16),
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
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    if (diasSelecionados[dia]!)
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            horarioInput(
                                              horariosControllers[dia]!['inicio']!,
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6,
                                              ),
                                              child: Text('-'),
                                            ),
                                            horarioInput(
                                              horariosControllers[dia]!['fim']!,
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

                      const SizedBox(height: 45), // Aumentado para igualar ao CadastroPage

                      // BOTÃO CONTINUAR (Padronizado com CadastroPage)
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // Ação de continuar
                          },
                          child: const Text(
                            'CONTINUAR ➜',
                            style: TextStyle(
                              color: Color(0xFF111934),
                              fontSize: 20, // Aumentado para 18
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
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

  Widget horarioInput(TextEditingController controller) {
    return Container(
      width: 65,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 14),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          HorarioInputFormatter(),
          LengthLimitingTextInputFormatter(5),
        ],
        decoration: const InputDecoration(
          hintText: '00:00',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class HorarioInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    if (text.length > 2 && !text.contains(':')) {
      text = text.substring(0, 2) + ':' + text.substring(2);
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
