import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_empresa.dart'; // Importando a nova página criada

class CadastroEmpresaPage extends StatefulWidget {
  const CadastroEmpresaPage({super.key});

  @override
  State<CadastroEmpresaPage> createState() => _CadastroEmpresaPageState();
}

class _CadastroEmpresaPageState extends State<CadastroEmpresaPage> {
  String? tipoServico;
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController nomeEmpresaController = TextEditingController();

  final List<String> opcoesServico = [
    'Barbearia',
    'Beleza / Estética',
    'Consultório',
    'Educação',
    'Gastronomia / Restaurante',
    'Oficina Mecânica',
    'Pet Shop',
    'Saúde / Clínica',
    'Varejo / Loja',
    'Outros'
  ];

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
    for (var dia in diasSelecionados.keys) {
      horariosControllers[dia] = {
        'manha_inicio': TextEditingController(text: ''),
        'manha_fim': TextEditingController(text: ''),
        'tarde_inicio': TextEditingController(text: ''),
        'tarde_fim': TextEditingController(text: ''),
      };
    }
  }

  void validarECadastrar() {
    String nome = nomeEmpresaController.text.trim();
    String endereco = enderecoController.text.trim();

    if (nome.isEmpty || endereco.isEmpty || tipoServico == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Por favor, preencha o nome, endereço e tipo de serviço!'),
            backgroundColor: Colors.redAccent),
      );
      return;
    }

    // Navega para a Home da Empresa passando o nome dinâmico
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeEmpresaPage(nomeEmpresa: nome),
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
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Center(
                    child: Text('Empresa',
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                  ),
                ],
              ),
            ),
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
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Nome da empresa:',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black87)),
                            const SizedBox(height: 8),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF4F4F4),
                                  borderRadius: BorderRadius.circular(12)),
                              child: TextField(
                                controller: nomeEmpresaController,
                                decoration: const InputDecoration(
                                    hintText: 'nome do seu comércio',
                                    border: InputBorder.none),
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text('Tipo de serviço',
                                style: TextStyle(fontSize: 18)),
                            const SizedBox(height: 8),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF4F4F4),
                                  borderRadius: BorderRadius.circular(12)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: tipoServico,
                                  isExpanded: true,
                                  hint: const Text('seu tipo de serviço'),
                                  items: opcoesServico
                                      .map((value) => DropdownMenuItem(
                                          value: value, child: Text(value)))
                                      .toList(),
                                  onChanged: (value) =>
                                      setState(() => tipoServico = value),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text('Endereço:',
                                style: TextStyle(fontSize: 18)),
                            const SizedBox(height: 8),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF4F4F4),
                                  borderRadius: BorderRadius.circular(12)),
                              child: TextField(
                                controller: enderecoController,
                                decoration: const InputDecoration(
                                    hintText: 'rua, bairro, cidade',
                                    border: InputBorder.none),
                              ),
                            ),
                            const SizedBox(height: 22),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Dia de funcionamento',
                                    style: TextStyle(fontSize: 16)),
                                Text('Horários (Manhã / Tarde)',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...diasSelecionados.keys.map((dia) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: diasSelecionados[dia],
                                          onChanged: (value) => setState(() =>
                                              diasSelecionados[dia] = value!),
                                          activeColor: const Color(0xFF111934),
                                        ),
                                        SizedBox(width: 80, child: Text(dia)),
                                        if (diasSelecionados[dia]!)
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    const Text('M: ',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    horarioInput(
                                                        horariosControllers[
                                                                dia]![
                                                            'manha_inicio']!),
                                                    const Text(' - '),
                                                    horarioInput(
                                                        horariosControllers[
                                                                dia]![
                                                            'manha_fim']!),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    const Text('T: ',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    horarioInput(
                                                        horariosControllers[
                                                                dia]![
                                                            'tarde_inicio']!),
                                                    const Text(' - '),
                                                    horarioInput(
                                                        horariosControllers[
                                                                dia]![
                                                            'tarde_fim']!),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    const Divider(height: 1),
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
                          child: const Text('CONTINUAR ➜',
                              style: TextStyle(
                                  color: Color(0xFF111934),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
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
      width: 60,
      height: 28,
      decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(6)),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 13),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          HorarioInputFormatter(),
          LengthLimitingTextInputFormatter(5)
        ],
        decoration: const InputDecoration(
            hintText: '00:00',
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 6)),
      ),
    );
  }
}

class HorarioInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    if (text.length > oldValue.text.length) {
      if (text.length == 2 && !text.contains(':')) {
        text += ':';
      } else if (text.length == 3 && !text.contains(':')) {
        text = text.substring(0, 2) + ':' + text.substring(2);
      }
    }
    return TextEditingValue(
        text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}
