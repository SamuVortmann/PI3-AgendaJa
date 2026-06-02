import 'package:flutter/material.dart';
import 'perfil_cliente.dart';
import 'meus-agendamentos.dart'; // Importa a tela de agendamentos

class MenuCliente extends StatelessWidget {
  final String nome;
  final String telefone;

  const MenuCliente({
    super.key,
    required this.nome,
    required this.telefone,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: const Color(0xFF111934),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                  ),
                  Image.asset(
                    'assets/logo.png',
                    width: 50,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.circle, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Perfil do Usuário
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white, size: 35),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PerfilPage(
                                nome: nome,
                                telefone: telefone,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Editar perfil',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(color: Colors.white24, indent: 24, endIndent: 24),
            const SizedBox(height: 20),

            // Itens do Menu
            _buildMenuItem(
              context: context,
              titulo: 'Meus agendamentos',
              onTap: () {
                Navigator.pop(context); // Fecha o menu lateral
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MeusAgendamentosPage(), // Navega para a tela correta
                  ),
                );
              },
            ),

            _buildMenuItem(
              context: context,
              titulo: 'Notificações',
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const Spacer(),

            // Botão Sair
            Padding(
              padding: const EdgeInsets.all(24),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Sair da conta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String titulo,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Text(
          titulo,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
