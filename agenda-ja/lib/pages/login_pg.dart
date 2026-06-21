import 'package:flutter/material.dart';

import '../services/api_client.dart';
import '../services/auth_service.dart';
import 'home_empresa.dart';
import 'homecliente.dart';

class LoginPg extends StatefulWidget {
  const LoginPg({super.key});

  @override
  State<LoginPg> createState() => _LoginPgState();
}

class _LoginPgState extends State<LoginPg> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;

  Future<void> _fazerLogin() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      _mostrarErro('Preencha e-mail e senha.');
      return;
    }

    setState(() => _carregando = true);
    try {
      final usuario = await AuthService.instance.login(
        email: email,
        senha: senha,
      );
      if (!mounted) return;

      if (usuario.isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeEmpresaPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeClientePage()),
        );
      }
    } on ApiException catch (e) {
      _mostrarErro(e.message);
    } catch (_) {
      _mostrarErro('Não foi possível conectar à API. Verifique se o servidor está rodando.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _mostrarErro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 220,
                      color: const Color(0xFF111934),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 40,
                            left: 10,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 60),
                                Image.asset('assets/logo.png', width: 130),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                          child: Column(
                            children: [
                              const Text(
                                'Login',
                                style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 40),
                              _campo('Email:', _emailController, hint: 'seuemail@gmail.com'),
                              const SizedBox(height: 20),
                              _campo('Senha:', _senhaController, hint: '************', obscure: true),
                              const SizedBox(height: 35),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _carregando ? null : _fazerLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF111934),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: _carregando
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                        )
                                      : const Text('login', style: TextStyle(fontSize: 20)),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Não tem uma conta? ', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54)),
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamed(context, '/cadastro'),
                                    child: const Text(
                                      'CADASTRE-SE',
                                      style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF111934), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _campo(String titulo, TextEditingController controller, {String? hint, bool obscure = false}) {
    return Container(
      width: double.infinity,
      height: 85,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: titulo.contains('Email') ? TextInputType.emailAddress : TextInputType.text,
            decoration: InputDecoration(hintText: hint, border: InputBorder.none, isCollapsed: true),
          ),
        ],
      ),
    );
  }
}
