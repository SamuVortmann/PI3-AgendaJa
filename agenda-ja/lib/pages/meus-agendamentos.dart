import 'package:flutter/material.dart';

class MeusAgendamentosPage extends StatelessWidget {
  const MeusAgendamentosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            // NAVBAR com Botão de Voltar e LOGO
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              color: const Color(0xFF111934),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png',
                        width: 100,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Equilíbrio visual para centralizar a logo
                ],
              ),
            ),

            // CONTEÚDO
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Meus agendamentos',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // SEÇÃO FUTUROS
                      secaoTitulo('Futuros:'),
                      cardAgendamento(
                        data: '10/06/2026',
                        local: 'Clinica Tesser - Concórdia',
                        horario: '16:50',
                        cor: const Color(0xFF111934),
                      ),
                      cardAgendamento(
                        data: '25/07/2026',
                        local: 'Hospital São Francisco',
                        horario: '08:10',
                        cor: const Color(0xFF111934),
                      ),

                      const SizedBox(height: 20),

                      // SEÇÃO PASSADOS
                      secaoTitulo('Passados:'),
                      cardAgendamento(
                        data: '28/05/2026',
                        local: 'Clinica vida - Concórdia',
                        horario: '15:30',
                        cor: const Color(0xFF111934),
                      ),

                      const SizedBox(height: 20),

                      // SEÇÃO CANCELADOS
                      const Text(
                        'Cancelados:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB71C1C), // Vermelho escuro para o título
                        ),
                      ),
                      const SizedBox(height: 10),
                      cardAgendamento(
                        data: '28/05/2026',
                        local: 'Salão Bela Vista - Irani',
                        horario: '18:00',
                        cor: const Color(0xFFB71C1C), // Vermelho para o card
                        isCancelado: true,
                      ),
                      const SizedBox(height: 30),
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

  Widget secaoTitulo(String titulo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF111934),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        titulo,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget cardAgendamento({
    required String data,
    required String local,
    required String horario,
    required Color cor,
    bool isCancelado = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '→ $data',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'local: $local',
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          Text(
            'Horário: $horario',
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          if (!isCancelado)
            const Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Ver detalhes',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
