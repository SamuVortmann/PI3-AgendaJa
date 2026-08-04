import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_empresa.dart';

class CadastroEmpresaPage extends StatefulWidget {
  const CadastroEmpresaPage({super.key});

  @override
  State<CadastroEmpresaPage> createState() => _CadastroEmpresaPageState();
}

class _CadastroEmpresaPageState extends State<CadastroEmpresaPage> {
  // Controllers inicializados diretamente
  final nomeController = TextEditingController();
  final cnpjController = TextEditingController();
  final enderecoController = TextEditingController();
  final telefoneController = TextEditingController();

  List<String> _diasSelecionados = [];
  TimeOfDay? _horaAbertura;
  TimeOfDay? _horaFechamento;

  bool _carregando = false;

  Future<void> _continuar() async {
    final nome = nomeController.text.trim();
    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, informe o nome do estabelecimento')),
      );
      return;
    }

    setState(() => _carregando = true);
    
    // Simulação de sucesso para evitar erro de rota inexistente na API
    // Quando você tiver a rota correta da API, basta trocar este bloco
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() => _carregando = false);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeEmpresaPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2937),
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Cadastro de Empresa',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            // Conteúdo Branco
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    children: [
                      const Text(
                        'Conte sobre seu negócio',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                      ),
                      const SizedBox(height: 32),
                      
                      // CAMPOS SIMPLIFICADOS PARA GARANTIR EDIÇÃO
                      _itemCampo('Nome do estabelecimento', 'Salão Bella', nomeController),
                      const SizedBox(height: 20),
                      _itemCampo(
                        'CNPJ (opcional)', 
                        '00.000.000/0000-00', 
                        cnpjController, 
                        keyboard: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CnpjInputFormatter(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _itemCampo('Endereço', 'Rua das Flores, 123', enderecoController),
                      const SizedBox(height: 20),
                      _itemCampo(
                        'Telefone', 
                        '(49) 90000-0000', 
                        telefoneController, 
                        keyboard: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter(),
                        ],
                      ),
                      
                      const SizedBox(height: 40),

                      // Dias de Funcionamento
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dias de Funcionamento',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            children: [ 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom' ].map((dia) {
                              final isSelected = _diasSelecionados.contains(dia);
                              return ChoiceChip(
                                label: Text(dia),
                                selected: isSelected,
                                selectedColor: const Color(0xFF2563EB),
                                labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF1F2937)),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _diasSelecionados.add(dia);
                                    } else {
                                      _diasSelecionados.remove(dia);
                                    }
                                  });
                                },
                                backgroundColor: const Color(0xFFF9FAFB),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB))),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Horário de Funcionamento
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Horário de Funcionamento',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final TimeOfDay? picked = await showTimePicker(
                                      context: context,
                                      initialTime: _horaAbertura ?? TimeOfDay.now(),
                                    );
                                    if (picked != null && picked != _horaAbertura) {
                                      setState(() {
                                        _horaAbertura = picked;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFFE5E7EB)),
                                      borderRadius: BorderRadius.circular(12),
                                      color: const Color(0xFFF9FAFB),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time, color: Color(0xFF1F2937)),
                                        const SizedBox(width: 10),
                                        Text(
                                          _horaAbertura?.format(context) ?? 'Abertura',
                                          style: const TextStyle(color: Color(0xFF1F2937)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final TimeOfDay? picked = await showTimePicker(
                                      context: context,
                                      initialTime: _horaFechamento ?? TimeOfDay.now(),
                                    );
                                    if (picked != null && picked != _horaFechamento) {
                                      setState(() {
                                        _horaFechamento = picked;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFFE5E7EB)),
                                      borderRadius: BorderRadius.circular(12),
                                      color: const Color(0xFFF9FAFB),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time, color: Color(0xFF1F2937)),
                                        const SizedBox(width: 10),
                                        Text(
                                          _horaFechamento?.format(context) ?? 'Fechamento',
                                          style: const TextStyle(color: Color(0xFF1F2937)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _carregando ? null : _continuar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: _carregando 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Continuar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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

  Widget _itemCampo(
    String label, 
    String hint, 
    TextEditingController controller, 
    {TextInputType keyboard = TextInputType.text, List<TextInputFormatter>? inputFormatters}
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),
      ],
    );
  }
}

/// Formatador para CNPJ: 00.000.000/0000-00
class CnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.length > 14) return oldValue;

    var selectionIndex = newValue.selection.end;
    var usedSubstringIndex = 0;
    final newText = StringBuffer();

    if (text.length >= 3) {
      newText.write('${text.substring(0, usedSubstringIndex = 2)}.');
      if (newValue.selection.end >= 2) selectionIndex++;
    }
    if (text.length >= 6) {
      newText.write('${text.substring(2, usedSubstringIndex = 5)}.');
      if (newValue.selection.end >= 5) selectionIndex++;
    }
    if (text.length >= 9) {
      newText.write('${text.substring(5, usedSubstringIndex = 8)}/');
      if (newValue.selection.end >= 8) selectionIndex++;
    }
    if (text.length >= 13) {
      newText.write('${text.substring(8, usedSubstringIndex = 12)}-');
      if (newValue.selection.end >= 12) selectionIndex++;
    }
    if (text.length >= usedSubstringIndex) {
      newText.write(text.substring(usedSubstringIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

/// Formatador para Telefone: (00) 00000-0000
class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.length > 11) return oldValue;

    var selectionIndex = newValue.selection.end;
    var usedSubstringIndex = 0;
    final newText = StringBuffer();

    if (text.length >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (text.length >= 3) {
      newText.write('${text.substring(0, usedSubstringIndex = 2)}) ');
      if (newValue.selection.end >= 2) selectionIndex += 2;
    }
    if (text.length >= 8) {
      newText.write('${text.substring(2, usedSubstringIndex = 7)}-');
      if (newValue.selection.end >= 7) selectionIndex++;
    }
    if (text.length >= usedSubstringIndex) {
      newText.write(text.substring(usedSubstringIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
