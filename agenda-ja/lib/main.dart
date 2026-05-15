import 'package:flutter/material.dart';
import 'pages/primeira_pg.dart';
import 'pages/login_pg.dart';
import 'pages/cadastro.dart';
import 'pages/homecliente.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      routes: {
        '/login': (context) => const LoginPg(),
        '/cadastro': (context) => const CadastroPage(),
      },

      home: const PaginaInicial(),
    );
  }
}