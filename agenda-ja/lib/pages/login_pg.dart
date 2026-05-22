import 'package:flutter/material.dart';
import 'cadastro.dart';

class LoginPg extends StatelessWidget {
  const LoginPg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              // Define que o conteúdo deve ter no mínimo a altura total da tela
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Parte Superior: Logo e Título (Fundo Azul) + Botão de Voltar
                    Container(
                      width: double.infinity,
                      height: 220,
                      color: const Color(0xFF111934),
                      child: Stack(
                        children: [
                          // Botão de Voltar
                          Positioned(
                            top: 40,
                            left: 10,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          // Logo e Título centralizados
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 40),
                                Image.asset(
                                  'assets/logo.png',
                                  width: 110,
                                ),
                                const Text(
                                  'Agenda já',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Parte Inferior: Expandida para preencher o resto da tela
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 40),
                          child: Column(
                            children: [
                              const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Campo de Email
                              Container(
                                width: double.infinity,
                                height: 85,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Email:',
                                        style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 5),
                                    TextField(
                                      decoration: InputDecoration(
                                        hintText: 'seuemail@gmail.com',
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Campo de Senha
                              Container(
                                width: double.infinity,
                                height: 85,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Senha:',
                                        style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 5),
                                    TextField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: '************',
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 35),

                              // Botão de Login
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF111934),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('login',
                                      style: TextStyle(fontSize: 20)),
                                ),
                              ),

                              const SizedBox(height: 20),

                              const Text(
                                'Esqueci minha senha',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Não tem uma conta? ',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black54,
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CadastroPage(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'CADASTRE-SE',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Color(0xFF111934),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Spacer ou SizedBox para garantir que o conteúdo não fique colado no fundo
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
}
