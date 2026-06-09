import 'package:flutter/material.dart';
import 'agendar.dart';
import 'dados_globais.dart';
// import 'cadastro.dart'; // Removido pois não está sendo utilizado nesta página

class HomeEmpresaPage extends StatelessWidget {
  final String nomeEmpresa;

  const HomeEmpresaPage({super.key, required this.nomeEmpresa});

  @override
  Widget build(BuildContext context) {
    // Busca os agendamentos para a data de hoje (ou uma data específica)
    // Sugestão: usar uma data dinâmica se o DadosGlobais suportar,
    // mas mantive a lógica do seu código original com uma pequena melhoria.
    final String dataHoje = '2026-05-28';
    final List<Map<String, String>> agendamentos =
        DadosGlobais.getAgendamentosPorData(dataHoje);

    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            // Header / Logo
            Container(
              width: double.infinity,
              height: 100,
              color: const Color(0xFF111934),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        // Espaço para abrir um Drawer ou Menu
                      },
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'A',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'Agenda Já',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Conteúdo Principal
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 30,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          nomeEmpresa,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      const Text(
                        'Resumo do dia:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111934),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '→ Hoje você tem ${agendamentos.length} agendamentos',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const Text(
                              '→ 2 horários livres', // Valor estático conforme original
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                'clique em agenda para verificar',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Próximos clientes:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111934),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: agendamentos.isEmpty
                            ? const Center(
                                child: Text(
                                  'Nenhum agendamento para hoje',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            : Column(
                                children: agendamentos
                                    .map(
                                      (ag) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              '→ ',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${ag['nome'] ?? 'Cliente'} - ${ag['horario'] ?? '--:--'}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                      ),
                      const SizedBox(height: 40),
                      botaoAcao('Ver agenda', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AgendarPage(nomeEmpresa: nomeEmpresa),
                          ),
                        );
                      }),
                      const SizedBox(height: 15),
                      botaoAcao('Ver clientes', () {
                        // Lógica para ver clientes
                      }),
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

  Widget botaoAcao(String titulo, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF111934),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          titulo,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
