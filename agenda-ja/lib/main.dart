import 'package:flutter/material.dart';

import 'pages/admin_gestao_page.dart';
import 'pages/cadastro.dart';
import 'pages/cadastro_empresa.dart';
import 'pages/confirmacao_agendamento.dart';
import 'pages/detalhes_empresa.dart';
import 'pages/home_empresa.dart';
import 'pages/homecliente.dart';
import 'pages/login_pg.dart';
import 'pages/primeira_pg.dart';
import 'services/auth_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthSession.instance.load();
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda Já',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF111934)),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const PaginaInicial(),
        '/login': (context) => const LoginPg(),
        '/cadastro': (context) => const CadastroPage(),
        '/home_cliente': (context) => const HomeClientePage(),
        '/home_empresa': (context) => const HomeEmpresaPage(),
        '/admin_gestao': (context) => const AdminGestaoPage(),
        '/admin_agenda': (context) => const AgendaPage(),
        '/detalhes_empresa': (context) => const AgendamentoEmpresaDetalhesPage(),
        '/confirmacao': (context) => const ConfirmacaoAgendamentoPage(),
      },
      home: const PaginaInicial(),
    );
  }
}
