import 'package:flutter/material.dart';

class DetalhesAgendamentoPage extends StatefulWidget {
  const DetalhesAgendamentoPage({super.key});

  @override
  State<DetalhesAgendamentoPage> createState() => _DetalhesAgendamentoPageState();
}

class _DetalhesAgendamentoPageState extends State<DetalhesAgendamentoPage> {
  String status = 'Confirmado';
  Color statusColor = Colors.green;

  void cancelarAgendamento() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Agendamento?'),
        content: const Text('Você tem certeza que deseja cancelar este agendamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                status = 'Cancelado';
                statusColor = const Color(0xFFB71C1C);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Agendamento cancelado.'), backgroundColor: Colors.redAccent),
              );
            },
            child: const Text('Sim, cancelar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void mostrarAviso(String acao) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Funcionalidade de $acao será implementada em breve!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image, color: Colors.white),
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
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Detalhes agendamento', style: TextStyle(fontSize: 18, color: Colors.black)),
                      ),
                      const SizedBox(height: 20),

                      // CARD AZUL DE DETALHES
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111934),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Clinica Tesser - Concórdia',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                            const SizedBox(height: 25),
                            const Text('Data: 10/06/2026', style: TextStyle(color: Colors.white, fontSize: 16)),
                            const SizedBox(height: 10),
                            const Text('Horário: 16:50', style: TextStyle(color: Colors.white, fontSize: 16)),
                            const SizedBox(height: 10),
                            const Text(
                              'Endereço: Rua Prefeito Domingos Machado de Lima, 755 - Centro, Concórdia - SC, 89700-075',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(height: 25),
                            
                            // STATUS DINÂMICO
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                status,
                                style: TextStyle(color: statusColor, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            
                            const SizedBox(height: 30),

                            // BOTÕES DE AÇÃO FUNCIONAIS
                            Center(
                              child: Column(
                                children: [
                                  _buildActionButton('Editar', width: 180, onTap: () => mostrarAviso('Editar')),
                                  const SizedBox(height: 15),
                                  _buildActionButton('Remarcar', width: 280, onTap: () => mostrarAviso('Remarcar')),
                                  const SizedBox(height: 10),
                                  _buildActionButton('Cancelar', width: 280, onTap: status == 'Cancelado' ? null : cancelarAgendamento),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      GestureDetector(
                        onTap: () => mostrarAviso('Falar com a empresa'),
                        child: const Text(
                          'Falar com a empresa',
                          style: TextStyle(color: Colors.black, fontSize: 16, decoration: TextDecoration.underline, fontStyle: FontStyle.italic),
                        ),
                      ),
                      const SizedBox(height: 20),
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

  Widget _buildActionButton(String titulo, {required double width, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: onTap == null ? Colors.grey : const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          titulo,
          style: TextStyle(color: onTap == null ? Colors.white70 : Colors.black87, fontSize: 16),
        ),
      ),
    );
  }
}
