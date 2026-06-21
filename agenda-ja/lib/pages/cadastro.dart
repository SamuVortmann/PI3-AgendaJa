import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/api_client.dart';
import '../services/auth_service.dart';
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
  bool _carregando = false;

  Future<void> validarECadastrar() async {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final telefone = telefoneController.text.trim();
    final senha = senhaController.text;
    final confirmarSenha = confirmarSenhaController.text;

    if (nome.isEmpty || email.isEmpty || telefone.isEmpty || senha.isEmpty || confirmarSenha.isEmpty) {
      exibirMensagem('Por favor, preencha todos os campos!');
      return;
    }

    if (tipoConta.isEmpty) {
      exibirMensagem('Selecione se você é Cliente ou Empresa!');
      return;
    }

    if (senha != confirmarSenha) {
      exibirMensagem('As senhas não coincidem!');
      return;
    }

    if (senha.length < 6) {
      exibirMensagem('A senha deve ter pelo menos 6 caracteres!');
      return;
    }

    if (tipoConta == 'empresa') {
      exibirMensagem(
        'Contas de empresa/admin são criadas pelo administrador. Use login com admin@agendaja.com',
      );
      return;
    }

    setState(() => _carregando = true);
    try {
      await AuthService.instance.register(
        nome: nome,
        email: email,
        senha: senha,
        telefone: telefone,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeClientePage()),
      );
    } on ApiException catch (e) {
      exibirMensagem(e.message);
    } catch (_) {
      exibirMensagem('Erro ao conectar com a API. Verifique se o servidor está rodando.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void exibirMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.redAccent, duration: const Duration(seconds: 3)),
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
                            child: Text('Cadastro', style: TextStyle(color: Colors.white, fontSize: 30)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: constraints.maxHeight - 120),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
                        child: Column(
                          children: [
                            campo(titulo: 'Nome completo:', hint: 'seu nome completo', controller: nomeController),
                            const SizedBox(height: 22),
                            campo(titulo: 'Email:', hint: 'seuemail@gmail.com', controller: emailController),
                            const SizedBox(height: 22),
                            campoTelefone(),
                            const SizedBox(height: 22),
                            campo(titulo: 'Senha:', hint: '**************', controller: senhaController, obscure: true),
                            const SizedBox(height: 22),
                            campo(titulo: 'Confirmar senha:', hint: '**************', controller: confirmarSenhaController, obscure: true),
                            const SizedBox(height: 22),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Tipo de conta:', style: TextStyle(fontSize: 16)),
                                  Row(
                                    children: [
                                      Radio<String>(
                                        value: 'cliente',
                                        groupValue: tipoConta,
                                        activeColor: const Color(0xFF111934),
                                        onChanged: (v) => setState(() => tipoConta = v!),
                                      ),
                                      const Text('Cliente'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio<String>(
                                        value: 'empresa',
                                        groupValue: tipoConta,
                                        activeColor: const Color(0xFF111934),
                                        onChanged: (v) => setState(() => tipoConta = v!),
                                      ),
                                      const Text('Empresa/ profissional'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 45),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: _carregando ? null : validarECadastrar,
                                child: _carregando
                                    ? const CircularProgressIndicator()
                                    : const Text('CONTINUAR ➜', style: TextStyle(color: Color(0xFF111934), fontSize: 18, fontWeight: FontWeight.bold)),
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

  Widget campo({required String titulo, required String hint, required TextEditingController controller, bool obscure = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.grey), border: InputBorder.none, isCollapsed: true),
          ),
        ],
      ),
    );
  }

  Widget campoTelefone() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Telefone:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          TextField(
            controller: telefoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [TelefoneInputFormatter()],
            decoration: const InputDecoration(hintText: '(49)99999-9999', border: InputBorder.none, isCollapsed: true),
          ),
        ],
      ),
    );
  }
}

class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var numeros = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (numeros.length > 11) numeros = numeros.substring(0, 11);

    var textoFormatado = '';
    if (numeros.isNotEmpty) {
      textoFormatado += '(';
      textoFormatado += numeros.substring(0, numeros.length >= 2 ? 2 : numeros.length);
      if (numeros.length >= 2) textoFormatado += ')';
    }
    if (numeros.length > 2) {
      textoFormatado += numeros.substring(2, numeros.length >= 7 ? 7 : numeros.length);
    }
    if (numeros.length > 7) textoFormatado += '-${numeros.substring(7)}';

    return TextEditingValue(text: textoFormatado, selection: TextSelection.collapsed(offset: textoFormatado.length));
  }
}
