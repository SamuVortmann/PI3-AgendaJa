import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/api_client.dart';
import '../services/auth_service.dart';
import 'homecliente.dart';
import 'cadastro_empresa.dart';
import 'login_pg.dart'; // Importação da página de login

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

    if (nome.isEmpty ||
        email.isEmpty ||
        telefone.isEmpty ||
        senha.isEmpty ||
        confirmarSenha.isEmpty) {
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

    setState(() => _carregando = true);
    try {
      // Nota: Se o erro "relação de empresa não existente" persistir,
      // verifique se o backend exige um empresa_id inicial para o tipo 'empresa'.
      await AuthService.instance.register(
        nome: nome,
        email: email,
        senha: senha,
        telefone: telefone,
        tipoConta: tipoConta,
      );

      if (!mounted) return;

      if (tipoConta == 'empresa') {
        // Redireciona para o cadastro de detalhes da empresa
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CadastroEmpresaPage()),
        );
      } else {
        // Redireciona para a home do cliente
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeClientePage()),
        );
      }
    } on ApiException catch (e) {
      exibirMensagem(e.message);
    } catch (e) {
      exibirMensagem('Erro ao realizar cadastro. Tente novamente.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void exibirMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2937),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1F2937),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Criar conta',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 80,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 30,
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Vamos começar',
                              style: TextStyle(
                                color: Color(0xFF1F2937),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            _campo(
                              titulo: 'Nome completo:',
                              hint: 'seu nome completo',
                              controller: nomeController,
                            ),
                            const SizedBox(height: 22),
                            _campo(
                              titulo: 'E-mail:',
                              hint: 'seuemail@gmail.com',
                              controller: emailController,
                            ),
                            const SizedBox(height: 22),
                            _campoTelefone(),
                            const SizedBox(height: 22),
                            _campo(
                              titulo: 'Senha:',
                              hint: '**************',
                              controller: senhaController,
                              obscure: true,
                            ),
                            const SizedBox(height: 22),
                            _campo(
                              titulo: 'Confirmar senha:',
                              hint: '**************',
                              controller: confirmarSenhaController,
                              obscure: true,
                            ),
                            const SizedBox(height: 30),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Tipo de conta',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildAccountTypeCard(
                              icon: Icons.person,
                              title: 'Sou Cliente',
                              subtitle: 'Quero encontrar profissionais',
                              value: 'cliente',
                              groupValue: tipoConta,
                              onChanged: (value) =>
                                  setState(() => tipoConta = value),
                            ),
                            const SizedBox(height: 15),
                            _buildAccountTypeCard(
                              icon: Icons.business,
                              title: 'Sou Profissional / Empresa',
                              subtitle: 'Quero gerenciar minha agenda',
                              value: 'empresa',
                              groupValue: tipoConta,
                              onChanged: (value) =>
                                  setState(() => tipoConta = value),
                            ),
                            const SizedBox(height: 35),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _carregando
                                    ? null
                                    : validarECadastrar,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: _carregando
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Continuar',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Já tem uma conta? ',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPg(),
                                    ),
                                  ),
                                  child: const Text(
                                    "Entrar",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFF2563EB),
                                      fontWeight: FontWeight.bold,
                                    ),
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

  Widget _campo({
    required String titulo,
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
              border: InputBorder.none,
              isCollapsed: true,
            ),
            style: const TextStyle(color: Color(0xFF1F2937)),
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
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB)
                : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFEFF6FF)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF9CA3AF),
                size: 28,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.check_circle,
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : const Color(0xFFD1D5DB),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _campoTelefone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Telefone:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: telefoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TelefoneInputFormatter(),
            ],
            decoration: const InputDecoration(
              hintText: '(00) 00000-0000',
              hintStyle: TextStyle(color: Color(0xFFD1D5DB)),
              border: InputBorder.none,
              isCollapsed: true,
            ),
            style: const TextStyle(color: Color(0xFF1F2937)),
          ),
        ),
      ],
    );
  }
}

class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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
