import 'package:flutter/material.dart';
import 'detalhes_agendamento.dart';
import 'dados_globais.dart'; // Certifique-se de que o nome do arquivo seja este

class MeusAgendamentosPage extends StatefulWidget {
  const MeusAgendamentosPage({super.key});

  @override
  State<MeusAgendamentosPage> createState() => _MeusAgendamentosPageState();
}

class _MeusAgendamentosPageState extends State<MeusAgendamentosPage> {
  @override
  Widget build(BuildContext context) {
    // CORREÇÃO: Usando o nome correto da lista e acessando via chave ['status']
    final futuros = DadosGlobais.meusAgendamentosCliente.where((ag) => ag['status'] == 'Futuro').toList();
    final passados = DadosGlobais.meusAgendamentosCliente.where((ag) => ag['status'] == 'Passado').toList();
    final cancelados = DadosGlobais.meusAgendamentosCliente.where((ag) => ag['status'] == 'Cancelado').toList();

    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            // NAVBAR
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
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // CONTEÚDO
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(45)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Meus agendamentos',
                        style: TextStyle(fontSize: 22, color: Colors.black87),
                      ),
                      const SizedBox(height: 25),

                      // SEÇÃO FUTUROS
                      if (futuros.isNotEmpty) ...[
                        secaoTitulo('Futuros:'),
                        ...futuros.map((ag) => cardAgendamento(context, ag)),
                      ],

                      const SizedBox(height: 20),

                      // SEÇÃO PASSADOS
                      if (passados.isNotEmpty) ...[
                        secaoTitulo('Passados:'),
                        ...passados.map((ag) => cardAgendamento(context, ag)),
                      ],

                      const SizedBox(height: 20),

                      // SEÇÃO CANCELADOS
                      if (cancelados.isNotEmpty) ...[
                        const Text(
                          'Cancelados:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
                        ),
                        const SizedBox(height: 10),
                        ...cancelados.map((ag) => cardAgendamento(context, ag, isCancelado: true)),
                      ],
                      
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
      child: Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  Widget cardAgendamento(BuildContext context, Map<String, dynamic> ag, {bool isCancelado = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isCancelado ? const Color(0xFFB71C1C) : const Color(0xFF111934),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('→ ${ag['data']}', style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 4),
          Text('local: ${ag['local']}', style: const TextStyle(color: Colors.white, fontSize: 15)),
          Text('Horário: ${ag['horario']}', style: const TextStyle(color: Colors.white, fontSize: 15)),
          if (!isCancelado)
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalhesAgendamentoPage(agendamentoId: ag['id']),
                    ),
                  );
                  setState(() {}); // Recarrega para ver a mudança de status
                },
                child: const Text(
                  'Ver detalhes',
                  style: TextStyle(color: Colors.white54, fontSize: 12, fontStyle: FontStyle.italic, decoration: TextDecoration.underline),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
