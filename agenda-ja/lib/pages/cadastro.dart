import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homecliente.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  String tipoConta = '';

  // Função para validar os campos
  void validarECadastrar() {
    String nome = nomeController.text.trim();
    String email = emailController.text.trim();
    String telefone = telefoneController.text.trim();
    String senha = senhaController.text;
    String confirmarSenha = confirmarSenhaController.text;

    // 1. Verificar se algum campo está vazio
    if (nome.isEmpty ||
        email.isEmpty ||
        telefone.isEmpty ||
        senha.isEmpty ||
        confirmarSenha.isEmpty) {
      exibirMensagem('Por favor, preencha todos os campos!');
      return;
    }

    // 2. Verificar se o tipo de conta foi selecionado
    if (tipoConta.isEmpty) {
      exibirMensagem('Selecione se você é Cliente ou Empresa!');
      return;
    }

    // 3. Verificar se as senhas são iguais
    if (senha != confirmarSenha) {
      exibirMensagem('As senhas não coincidem!');
      return;
    }

    // 4. Verificar tamanho mínimo da senha (exemplo: 6 caracteres)
    if (senha.length < 6) {
      exibirMensagem('A senha deve ter pelo menos 6 caracteres!');
      return;
    }

    // Se tudo estiver OK, navega para a Home
    if (tipoConta == 'cliente') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeClientePage(
            nome: nome,
            telefone: telefone,
          ),
        ),
      );
    } else {
      // Lógica para conta tipo Empresa (se houver uma página específica)
      exibirMensagem('Cadastro de Empresa realizado com sucesso!');
    }
  }

  // Função para exibir alertas simples
  void exibirMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
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
                    Container(
                      width: double.infinity,
                      height: 120,
                      color: const Color(0xFF111934),
                      child: const Center(
                        child: Text(
                          'Cadastro',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 120,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 30,
                        ),
                        child: Column(
                          children: [
                            campo(
                              titulo: 'Nome completo:',
                              hint: 'seu nome completo',
                              controller: nomeController,
                            ),
                            const SizedBox(height: 22),
                            campo(
                              titulo: 'Email:',
                              hint: 'seuemail@gmail.com',
                              controller: emailController,
                            ),
                            const SizedBox(height: 22),
                            campoTelefone(),
                            const SizedBox(height: 22),
                            campo(
                              titulo: 'Senha:',
                              hint: '**************',
                              controller: senhaController,
                              obscure: true,
                            ),
                            const SizedBox(height: 22),
                            campo(
                              titulo: 'Confirmar senha:',
                              hint: '**************',
                              controller: confirmarSenhaController,
                              obscure: true,
                            ),
                            const SizedBox(height: 22),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tipo de conta:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Radio(
                                        value: 'cliente',
                                        groupValue: tipoConta,
                                        activeColor: const Color(0xFF111934),
                                        onChanged: (value) {
                                          setState(() {
                                            tipoConta = value!;
                                          });
                                        },
                                      ),
                                      const Text('Cliente',
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                        value: 'empresa',
                                        groupValue: tipoConta,
                                        activeColor: const Color(0xFF111934),
                                        onChanged: (value) {
                                          setState(() {
                                            tipoConta = value!;
                                          });
                                        },
                                      ),
                                      const Text('Empresa/ profissional',
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 45),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap:
                                    validarECadastrar, // Chama a função de validação
                                child: const Text(
                                  'CONTINUAR ➜',
                                  style: TextStyle(
                                    color: Color(0xFF111934),
                                    fontSize: 18,
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget campo({
    required String titulo,
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
              isCollapsed: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget campoTelefone() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Telefone:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          TextField(
            controller: telefoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [TelefoneInputFormatter()],
            decoration: const InputDecoration(
              hintText: '(49)99999-9999',
              border: InputBorder.none,
              isCollapsed: true,
            ),
          ),
        ],
      ),
    );
  }
}

class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String numeros = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (numeros.length > 11) numeros = numeros.substring(0, 11);
    String textoFormatado = '';
    if (numeros.isNotEmpty)
      textoFormatado +=
          '(${numeros.substring(0, numeros.length >= 2 ? 2 : numeros.length)})';
    if (numeros.length > 2)
      textoFormatado +=
          numeros.substring(2, numeros.length >= 7 ? 7 : numeros.length);
    if (numeros.length > 7) textoFormatado += '-${numeros.substring(7)}';
    return TextEditingValue(
      text: textoFormatado,
      selection: TextSelection.collapsed(offset: textoFormatado.length),
    );
  }
}
