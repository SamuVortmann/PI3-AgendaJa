import 'package:flutter/material.dart';

class MenuCliente extends StatelessWidget {
  final String nome;

  const MenuCliente({
    super.key,
    required this.nome,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Remove a borda padrão do Drawer
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: const Color(0xFF111934),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com Ícone de Menu e Logo (como na imagem)
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
                  const SizedBox(width: 48), // Espaçador para equilibrar o Row
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
                      const Text(
                        'Editar perfil',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
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
                // Navegar para agendamentos
              },
            ),

            _buildMenuItem(
              context: context,
              titulo: 'Notificações',
              onTap: () {
                // Navegar para notificações
              },
            ),

            const Spacer(),

            // Botão Sair da Conta no rodapé
            Padding(
              padding: const EdgeInsets.all(24),
              child: InkWell(
                onTap: () {
                  // Lógica de logout
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
