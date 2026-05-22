import 'package:flutter/material.dart';
import 'cssprimeira_pg.dart';
import 'login_pg.dart';
import 'cadastro.dart';

class PaginaInicial extends StatelessWidget {
  const PaginaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CssPaginaInicial.background,
      body: Center(
        child: Column(
          children: [
            // Spacer no topo com flex maior para empurrar o conteúdo para baixo do meio
            const Spacer(flex: 2),

            Image.asset(
              'assets/logo.png',
              width: 250,
            ),

            const SizedBox(height: 5),

            // BOTÃO CADASTRO
            SizedBox(
              width: 260,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CadastroPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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

            // BOTÃO LOGIN
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            
            // Spacer no fundo com flex menor para garantir que não fique colado embaixo
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

