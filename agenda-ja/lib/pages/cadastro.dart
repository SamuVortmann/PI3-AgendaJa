import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homecliente.dart';
import 'cadastro_empresa.dart'; // Importação da nova página

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
  String tipoConta = 'cliente';

  void validarECadastrar() {
    String nome = nomeController.text;
    String email = emailController.text;
    String senha = senhaController.text;
    String confirmarSenha = confirmarSenhaController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      mostrarErro('Preencha todos os campos!');
      return;
    }

    if (senha != confirmarSenha) {
      mostrarErro('As senhas não coincidem!');
      return;
    }

    // LÓGICA DE NAVEGAÇÃO
    if (tipoConta == 'empresa') {
      // Se for empresa, vai para a página de Cadastro da Empresa
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroEmpresaPage(nomeResponsavel: nome),
        ),
      );
    } else {
      // Se for cliente, vai direto para a Home do Cliente
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeClientePage(nome: nome, telefone: ''),
        ),
      );
    }
  }

  void mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Cabeçalho
              Container(
                width: double.infinity,
                height: 120,
                alignment: Alignment.center,
                child: const Text(
                  'Cadastro',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              // Formulário
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    campo('Nome completo:', 'seu nome', nomeController),
                    const SizedBox(height: 20),
                    campo('Email:', 'seuemail@gmail.com', emailController),
                    const SizedBox(height: 20),
                    campoTelefone(),
                    const SizedBox(height: 20),
                    campo('Senha:', '********', senhaController, obscure: true),
                    const SizedBox(height: 20),
                    campo(
                      'Confirmar senha:',
                      '********',
                      confirmarSenhaController,
                      obscure: true,
                    ),
                    const SizedBox(height: 25),

                    // TIPO DE CONTA
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tipo de conta:'),
                          RadioListTile<String>(
                            title: const Text('Cliente'),
                            value: 'cliente',
                            groupValue: tipoConta,
                            onChanged: (v) => setState(() => tipoConta = v!),
                          ),
                          RadioListTile<String>(
                            title: const Text('Empresa/Profissional'),
                            value: 'empresa',
                            groupValue: tipoConta,
                            onChanged: (v) => setState(() => tipoConta = v!),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: validarECadastrar,
                        child: const Text(
                          'CONTINUAR ➜',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111934),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget campo(
    String titulo,
    String hint,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: titulo,
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget campoTelefone() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: telefoneController,
        keyboardType: TextInputType.phone,
        inputFormatters: [TelefoneInputFormatter()],
        decoration: const InputDecoration(
          labelText: 'Telefone:',
          hintText: '(49) 99999-9999',
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue newVal,
  ) {
    String t = newVal.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (t.length > 11) t = t.substring(0, 11);
    String f = '';
    if (t.isNotEmpty) {
      f += '(' + t.substring(0, t.length >= 2 ? 2 : t.length);
      if (t.length >= 2) f += ') ';
    }
    if (t.length > 2) f += t.substring(2, t.length >= 7 ? 7 : t.length);
    if (t.length > 7) f += '-' + t.substring(7);
    return TextEditingValue(
      text: f,
      selection: TextSelection.collapsed(offset: f.length),
    );
  }
}
