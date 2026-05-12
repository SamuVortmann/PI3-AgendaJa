import 'package:flutter/material.dart';
import 'cssprimeira_pg.dart';
import 'login_pg.dart';

class PaginaInicial extends StatelessWidget {
  const PaginaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CssPaginaInicial.background,

      body: Padding(
        padding: const EdgeInsets.only(top: 140),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Image.asset(
                'assets/logo.png',
                width: 220,
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: 260,
                height: 45,

                child: ElevatedButton(
                  onPressed: () {},

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),

                  child: const Text(
                    'Cadastro',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: 260,
                height: 45,

                child: ElevatedButton(
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPg(),
                      ),
                    );

                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),

                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}