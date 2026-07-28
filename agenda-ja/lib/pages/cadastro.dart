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
                      height: 150,
                      color: const Color(0xFF111934),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50, left: 20),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Criar conta',
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: constraints.maxHeight - 150),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
                        child: Column(
                          children: [
                            const Text(
                              'Vamos começar',
                              style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 30),
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
                            const SizedBox(height: 22),
                            _buildAccountTypeCard(
                              icon: Icons.person,
                              title: 'Sou Cliente',
                              subtitle: 'Quero encontrar profissionais',
                              value: 'cliente',
                              groupValue: tipoConta,
                              onChanged: (value) => setState(() => tipoConta = value),
                            ),
                            const SizedBox(height: 15),
                            _buildAccountTypeCard(
                              icon: Icons.business,
                              title: 'Sou Profissional / Empresa',
                              subtitle: 'Quero gerenciar minha agenda',
                              value: 'empresa',
                              groupValue: tipoConta,
                              onChanged: (value) => setState(() => tipoConta = value),
                            ),
                            const SizedBox(height: 35),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _carregando ? null : validarECadastrar,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4285F4),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: _carregando
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Text('Criar conta', style: TextStyle(fontSize: 20)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Já tem uma conta? ', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54)),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, 'login'),
                                  child: const Text(
                                    "Entrar",
                                    style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF4285F4), fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: const TextStyle(fontSize: 16, color: Colors.black)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.grey), border: InputBorder.none, isCollapsed: true),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountTypeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required String groupValue,
    required ValueChanged<String> onChanged,
  }) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF4285F4) : Colors.grey.shade300, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE3F2FD) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: isSelected ? const Color(0xFF4285F4) : Colors.grey.shade600, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  Widget campoTelefone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Telefone:', style: TextStyle(fontSize: 16, color: Colors.black)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: telefoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [TelefoneInputFormatter()],
            decoration: const InputDecoration(hintText: '(49)99999-9999', border: InputBorder.none, isCollapsed: true),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
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
