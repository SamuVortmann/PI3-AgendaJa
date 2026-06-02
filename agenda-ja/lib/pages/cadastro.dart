import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piteste/pages/home_empresa.dart';
import 'homecliente.dart';
import 'cadastro_empresa.dart';
import 'home_empresa.dart';

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

    // Verificar campos vazios
    if (nome.isEmpty ||
        email.isEmpty ||
        telefone.isEmpty ||
        senha.isEmpty ||
        confirmarSenha.isEmpty) {
      exibirMensagem('Por favor, preencha todos os campos!');
      return;
    }

    // Verificar tipo de conta
    if (tipoConta.isEmpty) {
      exibirMensagem('Selecione se você é Cliente ou Empresa!');
      return;
    }

    // Verificar senha
    if (senha != confirmarSenha) {
      exibirMensagem('As senhas não coincidem!');
      return;
    }

    // Verificar tamanho mínimo
    if (senha.length < 6) {
      exibirMensagem('A senha deve ter pelo menos 6 caracteres!');
      return;
    }

    // Navegação
    if (tipoConta == 'cliente') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeClientePage(nome: nome, telefone: telefone),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeEmpresaPage()),
      );
    }
  }

  // Exibir mensagens
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
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    // Cabeçalho com botão de voltar
                    Container(
                      width: double.infinity,
                      height: 120,
                      color: const Color(0xFF111934),
                      child: Stack(
                        children: [
                          // Botão de Voltar
                          Positioned(
                            top: 20,
                            left: 10,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          // Título centralizado
                          const Center(
                            child: Text(
                              'Cadastro',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
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
                                      const Text(
                                        'Cliente',
                                        style: TextStyle(fontSize: 16),
                                      ),
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
                                      const Text(
                                        'Empresa/ profissional',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
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

    if (numeros.length > 11) {
      numeros = numeros.substring(0, 11);
    }

    String textoFormatado = '';

    if (numeros.isNotEmpty) {
      textoFormatado +=
          '(${numeros.substring(0, numeros.length >= 2 ? 2 : numeros.length)})';
    }

    if (numeros.length > 2) {
      textoFormatado += numeros.substring(
        2,
        numeros.length >= 7 ? 7 : numeros.length,
      );
    }

    if (numeros.length > 7) {
      textoFormatado += '-${numeros.substring(7)}';
    }

    return TextEditingValue(
      text: textoFormatado,
      selection: TextSelection.collapsed(offset: textoFormatado.length),
    );
  }
}
