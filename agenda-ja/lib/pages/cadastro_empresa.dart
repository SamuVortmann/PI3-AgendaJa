import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dados_globais.dart';
import 'homecliente.dart'; // Importa sua Home atualizada

class CadastroEmpresaPage extends StatefulWidget {
  const CadastroEmpresaPage({super.key});

  @override
  State<CadastroEmpresaPage> createState() => _CadastroEmpresaPageState();
}

class _CadastroEmpresaPageState extends State<CadastroEmpresaPage> {
  String? tipoServico;
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController nomeEmpresaController = TextEditingController(); // Adicionei este controller

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
    enderecoController.dispose();
    nomeEmpresaController.dispose();
    super.dispose();
  }

  void validarECadastrar() {
    String nome = nomeEmpresaController.text.trim();
    String endereco = enderecoController.text.trim();

    if (nome.isEmpty || endereco.isEmpty || tipoServico == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha o nome, endereço e tipo de serviço!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // SALVA NA PRANCHETA GLOBAL
    DadosGlobais.adicionarEmpresa(
      nome: nome,
      endereco: endereco,
      categoria: tipoServico!,
    );

    // Navega para a Home
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeClientePage(nome: 'Empresa', telefone: ''),
      ),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Empresa cadastrada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

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
              height: 120,
              color: const Color(0xFF111934),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Empresa',
                      style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // NOME DA EMPRESA (Campo adicionado para integração)
                            const Text('Nome da empresa:', style: TextStyle(fontSize: 18, color: Colors.black87)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(color: const Color(0xFFF4F4F4), borderRadius: BorderRadius.circular(12)),
                              child: TextField(
                                controller: nomeEmpresaController,
                                decoration: const InputDecoration(hintText: 'nome do seu comércio', border: InputBorder.none),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // TIPO SERVIÇO
                            const Text('Tipo de serviço', style: TextStyle(fontSize: 18, color: Colors.black87)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE0E0E0))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: tipoServico,
                                  isExpanded: true,
                                  hint: const Text('seu tipo de serviço', style: TextStyle(fontSize: 14, color: Colors.grey)),
                                  items: ['Beleza', 'Saúde', 'Educação', 'Outros'].map((value) {
                                    return DropdownMenuItem(value: value, child: Text(value));
                                  }).toList(),
                                  onChanged: (value) => setState(() => tipoServico = value),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // ENDEREÇO
                            const Text('Endereço:', style: TextStyle(fontSize: 18)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(color: const Color(0xFFF4F4F4), borderRadius: BorderRadius.circular(12)),
                              child: TextField(
                                controller: enderecoController,
                                decoration: const InputDecoration(hintText: 'rua, bairro, cidade', border: InputBorder.none),
                              ),
                            ),
                            const SizedBox(height: 22),

                            // HORÁRIOS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Dia de funcionamento', style: TextStyle(fontSize: 16)),
                                Text('Horários', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...diasSelecionados.keys.map((dia) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: diasSelecionados[dia],
                                      onChanged: (value) => setState(() => diasSelecionados[dia] = value!),
                                      activeColor: const Color(0xFF111934),
                                    ),
                                    SizedBox(width: 80, child: Text(dia)),
                                    if (diasSelecionados[dia]!)
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            horarioInput(horariosControllers[dia]!['inicio']!),
                                            const Text(' - '),
                                            horarioInput(horariosControllers[dia]!['fim']!),
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
                      const SizedBox(height: 45),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: validarECadastrar,
                          child: const Text(
                            'CONTINUAR ➜',
                            style: TextStyle(color: Color(0xFF111934), fontSize: 20, fontWeight: FontWeight.bold),
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
      decoration: BoxDecoration(color: const Color(0xFFF4F4F4), borderRadius: BorderRadius.circular(8)),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly, HorarioInputFormatter(), LengthLimitingTextInputFormatter(5)],
        decoration: const InputDecoration(hintText: '00:00', border: InputBorder.none, isDense: true),
      ),
    );
  }
}

class HorarioInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    if (text.length > 2 && !text.contains(':')) text = text.substring(0, 2) + ':' + text.substring(2);
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}
