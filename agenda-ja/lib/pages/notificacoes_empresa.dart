import 'package:flutter/material.dart';

class NotificacoesEmpresaPage extends StatefulWidget {
  const NotificacoesEmpresaPage({super.key});

  @override
  State<NotificacoesEmpresaPage> createState() => _NotificacoesEmpresaPageState();
}

class _NotificacoesEmpresaPageState extends State<NotificacoesEmpresaPage> {
  // DADOS ESTÁTICOS (Mock)
  final List<Map<String, dynamic>> _notificacoesMock = [
    {
      'titulo': 'Lembrete de agendamento',
      'descricao': 'Corte de cabelo com Ana Souza às 14:00',
      'tempo': 'Hoje - 08:00',
      'icone': Icons.access_time,
      'corIcone': const Color(0xFF111934),
    },
    {
      'titulo': 'Agendamento confirmado',
      'descricao': 'Sua manicure foi confirmada para sexta',
      'tempo': 'Ontem - 18:32',
      'icone': Icons.check,
      'corIcone': const Color(0xFF111934),
    },
    {
      'titulo': 'Novo horário disponível',
      'descricao': 'Ana Souza abriu um novo horário livre',
      'tempo': '2 dias atrás',
      'icone': Icons.calendar_today,
      'corIcone': const Color(0xFF111934),
    },
    {
      'titulo': 'Agendamento cancelado',
      'descricao': 'Seu horário de barba foi cancelado',
      'tempo': '3 dias atrás',
      'icone': Icons.close,
      'corIcone': const Color(0xFF111934),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934), // Azul escuro do cabeçalho
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // CABEÇALHO (Header)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 24, 30),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 22,
                    ),
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

            // CONTEÚDO BRANCO COM A BORDA DE 60px
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60), // Borda de 60px conforme solicitado
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
            child: Icon(notif['icone'], size: 20, color: notif['corIcone']),
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
