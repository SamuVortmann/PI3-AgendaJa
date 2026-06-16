import 'package:flutter/material.dart';

class NotificacoesPage extends StatelessWidget {
  const NotificacoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934), // Azul escuro do cabeçalho
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: const Color(0xFF111934),
              child: Column(
                children: [
                  // LOGO
                  Column(
                    children: const [
                      Text(
                        'A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        'Agenda Já',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // TÍTULO
                  const Text(
                    'Notificações',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            
            // CORPO DA PÁGINA
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3), // Cinza claro do fundo
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // CARD 1
                      _buildNotificationCard(
                        icon: '✔',
                        text: 'Seu horário foi confirmado\nHoje • 14:30 • Prado Concept',
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // CARD 2
                      _buildNotificationCard(
                        icon: '⏰',
                        text: 'Você tem um horário amanhã\n09:00 • Clínica Vida',
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // CARD VAZIO (Como na imagem)
                      _buildNotificationCard(
                        icon: '',
                        text: '',
                      ),
                      
                      const Spacer(),
                      
                      // BOTÃO VOLTAR
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, size: 18, color: Colors.black87),
                          label: const Text(
                            'Voltar',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({required String icon, required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon.isNotEmpty) ...[
            Text(
              icon,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 10),
          ],
          if (text.isNotEmpty)
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
            ),
          if (text.isEmpty)
            const SizedBox(height: 20), // Altura mínima para card vazio
        ],
      ),
    );
  }
}
