import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'meus-agendamentos.dart';
import 'notificacoes.dart';
import 'perfil_cliente.dart';

class MenuCliente extends StatelessWidget {
  final String nome;
  final String telefone;

  const MenuCliente({super.key, required this.nome, required this.telefone});

  Future<void> _sair(BuildContext context) async {
    await AuthService.instance.logout();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: const Color(0xFF111934),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.menu, color: Colors.white, size: 30)),
                  Image.asset('assets/logo.png', width: 50, errorBuilder: (_, __, ___) => const Icon(Icons.circle, color: Colors.white, size: 30)),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const CircleAvatar(radius: 30, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white, size: 35)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nome, style: const TextStyle(color: Colors.white, fontSize: 18)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (_) => PerfilPage(nome: nome, telefone: telefone)));
                          },
                          child: const Text('Editar perfil', style: TextStyle(color: Colors.white70, decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white24, indent: 24, endIndent: 24),
            _buildMenuItem(context, 'Meus agendamentos', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MeusAgendamentosPage()));
            }),
            _buildMenuItem(context, 'Notificações', () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificacoesPage()));
            }),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: InkWell(
                onTap: () => _sair(context),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Text('Sair da conta', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String titulo, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        child: Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}
