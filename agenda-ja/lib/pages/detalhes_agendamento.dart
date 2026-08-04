import 'package:flutter/material.dart';

import '../services/agendamento_service.dart';
import '../services/api_client.dart';
import 'agendar.dart';

class DetalhesAgendamentoPage extends StatelessWidget {
  final Map<String, dynamic>? agendamento;

  const DetalhesAgendamentoPage({super.key, this.agendamento});

  Future<void> _cancelar(BuildContext context) async {
    final id = agendamento?['id'] as int?;
    if (id == null) return;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar agendamento?'),
        content: const Text(
          'O cancelamento só é permitido com pelo menos 2 horas de antecedência.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancelar agendamento'),
          ),
        ],
      ),
    );
    if (confirmar != true || !context.mounted) return;
    try {
      await AgendamentoService.instance.cancelar(id);
      if (context.mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usando dados passados ou valores padrão do wireframe
    final servico = agendamento?['servico'] ?? 'Corte de cabelo';
    final profissional = agendamento?['profissional'] ?? 'Ana Souza';
    final data = agendamento?['data'] ?? 'Qui, 30 Jul - 14:00';
    final status = agendamento?['status'] ?? 'confirmado';

    return Scaffold(
      backgroundColor: const Color(0xFF1F2937), // Azul marinho do topo
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO (Fiel ao wireframe)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Detalhes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // CARD DE INFORMAÇÃO PRINCIPAL
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF3F4F6)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      servico,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    Text(
                                      'com $profissional',
                                      style: const TextStyle(
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ],
                                ),
                                // Badge de Status
                                Container(
                                  width: 60,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: status == 'confirmado'
                                        ? const Color(0xFF22C55E)
                                        : const Color(0xFFF59E0B),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(color: Color(0xFFF3F4F6)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 18,
                                  color: Color(0xFF9CA3AF),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  data,
                                  style: const TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // DETALHES ADICIONAIS COM ÍCONES
                            _itemDetalhe(
                              Icons.access_time,
                              'Duração estimada: 45 min',
                            ),
                            const SizedBox(height: 16),
                            _itemDetalhe(
                              Icons.phone_outlined,
                              '(49) 90000-0000',
                            ),
                            const SizedBox(height: 16),
                            _itemDetalhe(Icons.star_border, 'Valor: R 45,00'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),

                      // BOTÃO REAGENDAR
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AgendarPage(),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Novo agendamento',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // BOTÃO CANCELAR
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: status == 'cancelado'
                              ? null
                              : () => _cancelar(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFEF4444)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancelar agendamento',
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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

  Widget _itemDetalhe(IconData icone, String texto) {
    return Row(
      children: [
        Icon(icone, size: 20, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 12),
        Text(
          texto,
          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 15),
        ),
      ],
    );
  }
}
