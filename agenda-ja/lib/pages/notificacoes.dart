import 'package:flutter/material.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  // DADOS ESTÁTICOS (Puro Front-End conforme o wireframe)
  final List<Map<String, dynamic>> _notificacoesMock = [
    {
      'titulo': 'Lembrete de agendamento',
      'descricao': 'Corte de cabelo com Ana Souza às 14:00',
      'tempo': 'Hoje - 08:00',
      'icone': Icons.access_time,
      'corIcone': const Color(0xFF1F2937),
    },
    {
      'titulo': 'Agendamento confirmado',
      'descricao': 'Sua manicure foi confirmada para sexta',
      'tempo': 'Ontem - 18:32',
      'icone': Icons.check,
      'corIcone': const Color(0xFF1F2937),
    },
    {
      'titulo': 'Novo horário disponível',
      'descricao': 'Ana Souza abriu um novo horário livre',
      'tempo': '2 dias atrás',
      'icone': Icons.calendar_today,
      'corIcone': const Color(0xFF1F2937),
    },
    {
      'titulo': 'Agendamento cancelado',
      'descricao': 'Seu horário de barba foi cancelado',
      'tempo': '3 dias atrás',
      'icone': Icons.close,
      'corIcone': const Color(0xFF1F2937),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2937), // Azul marinho do cabeçalho
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO (Fiel ao wireframe)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              width: double.infinity,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Notificações',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // CORPO BRANCO COM CANTO ARREDONDADO (60px)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  itemCount: _notificacoesMock.length,
                  itemBuilder: (context, index) {
                    final notif = _notificacoesMock[index];
                    return _buildNotificationItem(notif);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notif) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ícone em Container Arredondado
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              notif['icone'],
              size: 20,
              color: notif['corIcone'],
            ),
          ),
          const SizedBox(width: 16),
          // Textos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif['titulo'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notif['descricao'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notif['tempo'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
