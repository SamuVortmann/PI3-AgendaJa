import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgendaPage extends StatefulWidget {
  final String nomeEmpresa;

  const AgendaPage({super.key, required this.nomeEmpresa});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DateTime _dataSelecionada = DateTime(2026, 7, 30); // 30 de Julho de 2026 conforme wireframe

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (data != null) {
      setState(() => _dataSelecionada = data);
    }
  }

  Color _getCorStatus(String status) {
    switch (status.toLowerCase()) {
      case 'confirmado':
        return Colors.green;
      case 'pendente':
        return Colors.orange;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho mantendo o estilo original
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 20, bottom: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Agenda',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Conteúdo Branco com Borda Arredondada
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(60)),
                  child: Column(
                    children: [
                      // Seletor de Data Original
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 30, 25, 15),
                        child: InkWell(
                          onTap: _selecionarData,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFF4285F4),
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    DateFormat('dd/MM/yyyy').format(_dataSelecionada),
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
                                  ),
                                ),
                                const Icon(Icons.expand_more, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Quarta, 30 de Julho',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Expanded(child: _conteudoEstatico()),
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

  Widget _conteudoEstatico() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      children: [
        _buildStaticCard('Maria Silva', 'Corte de cabelo · 14:00', 'confirmado'),
        _buildStaticCard('João Pereira', 'Barba · 15:00', 'pendente'),
        _buildStaticCard('Ana Costa', 'Manicure · 16:30', 'confirmado'),
        _buildStaticCard('Bia Lima', 'Escova · 17:30', 'cancelado'),
      ],
    );
  }

  Widget _buildStaticCard(String nome, String detalhes, String status) {
    final statusCor = _getCorStatus(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.person, color: Colors.grey),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  detalhes,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            width: 45,
            height: 22,
            decoration: BoxDecoration(
              color: statusCor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}
