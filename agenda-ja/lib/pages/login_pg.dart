import 'package:flutter/material.dart';

class LoginPg extends StatelessWidget {
  const LoginPg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              width: double.infinity,
              height: 200,

              decoration: const BoxDecoration(
                color: Color(0xFF001F3D),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                ),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset(
                    'assets/logo.png',
                    width: 110,
                  ),

                  const SizedBox(height: 0),

                  const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),

              child: Column(
                children: [

                  // EMAIL

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

                        Text(
                          'Email:',
                          style: TextStyle(fontSize: 16),
                        ),

                        SizedBox(height: 5),

                        TextField(
                          style: TextStyle(fontSize: 16),

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

                  // SENHA

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

                        Text(
                          'Senha:',
                          style: TextStyle(fontSize: 16),
                        ),

                        SizedBox(height: 5),

                        TextField(
                          obscureText: true,
                          style: TextStyle(fontSize: 16),

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

                  // BOTÃO

                  SizedBox(
                    width: double.infinity,
                    height: 48,

                    child: ElevatedButton(
                      onPressed: () {},

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001F3D),
                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: const Text(
                        'login',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
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

                  const SizedBox(height: 5),

                  const Text(
                    'Não tem uma conta? CADASTRE-SE',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}