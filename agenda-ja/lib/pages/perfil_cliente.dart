import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  final String nome;
  final String telefone;

  const PerfilPage({
    super.key,
    required this.nome,
    required this.telefone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934), // Fundo azul escuro
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    // CABEÇALHO (Fundo Azul)
                    Container(
                      width: double.infinity,
                      height: 220, // Altura fixa para o cabeçalho
                      color: const Color(0xFF111934),
                      child: Stack(
                        children: [
                          // Botão de Voltar
                          Positioned(
                            top: 10,
                            left: 10,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          // Conteúdo Central do Cabeçalho
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/logo.png',
                                    width: 60,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.circle,
                                            color: Colors.white, size: 30),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 45,
                                        backgroundColor: Colors.white24,
                                        child: Icon(Icons.person,
                                            color: Colors.white, size: 50),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              nome,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Telefone: $telefone',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // CONTEÚDO (Fundo Cinza)
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 220,
                      ),
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
                            _buildProfileButton(
                              titulo: 'Editar Perfil',
                              onTap: () {},
                            ),
                            const SizedBox(height: 20),
                            _buildProfileButton(
                              titulo: 'Alterar senha',
                              onTap: () {},
                            ),
                            const SizedBox(height: 20),
                            _buildProfileButton(
                              titulo: 'Notificações',
                              onTap: () {},
                            ),

                            const SizedBox(height: 50),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/', (route) => false);
                                },
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.black54, size: 18),
                                label: const Text(
                                  'SAIR',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
          },
        ),
      ),
    );
  }

  Widget _buildProfileButton({
    required String titulo,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
