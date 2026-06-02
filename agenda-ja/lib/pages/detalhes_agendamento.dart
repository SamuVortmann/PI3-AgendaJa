import 'package:flutter/material.dart';

class DetalhesAgendamentoPage extends StatefulWidget {
  const DetalhesAgendamentoPage({super.key});

  @override
  State<DetalhesAgendamentoPage> createState() => _DetalhesAgendamentoPageState();
}

class _DetalhesAgendamentoPageState extends State<DetalhesAgendamentoPage> {
  String local = 'Clinica Tesser - Concórdia';
  String data = '10/06/2026';
  String horario = '16:50';
  String endereco = 'Rua Prefeito Domingos Machado de Lima, 755 - Centro, Concórdia - SC, 89700-075';
  String status = 'Confirmado';
  Color statusColor = Colors.green;

  // Variáveis temporárias para a seleção
  int diaSelecionado = 15;
  String horarioSelecionado = '08:00';

  void abrirRemarcar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder( // Necessário para atualizar o estado dentro do BottomSheet
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Color(0xFFF1F1F1),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 20),
                const Text('Selecione a nova data:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                
                // CALENDÁRIO VISUAL
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Junho 2026', style: TextStyle(fontWeight: FontWeight.bold)),
                          Icon(Icons.calendar_month, color: Color(0xFF111934)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                        itemCount: 30,
                        itemBuilder: (context, index) {
                          int dia = index + 1;
                          bool isSelecionado = dia == diaSelecionado;
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                setModalState(() => diaSelecionado = dia);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelecionado ? const Color(0xFF111934) : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Text('$dia', style: TextStyle(color: isSelecionado ? Colors.white : Colors.black)),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                const Text('Selecione o horário:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),

                // SELETOR DE HORÁRIOS
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ['08:00', '09:30', '11:00', '14:00', '15:30', '17:00'].map((h) {
                    bool isSelecionado = h == horarioSelecionado;
                    return GestureDetector(
                      onTap: () {
                        setModalState(() => horarioSelecionado = h);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelecionado ? const Color(0xFF111934) : Colors.white,
                          border: Border.all(color: const Color(0xFF111934)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(h, style: TextStyle(fontWeight: FontWeight.bold, color: isSelecionado ? Colors.white : Colors.black)),
                      ),
                    );
                  }).toList(),
                ),

                const Spacer(),

                // BOTÃO SALVAR
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          data = "${diaSelecionado.toString().padLeft(2, '0')}/06/2026";
                          horario = horarioSelecionado;
                          status = 'Remarcado';
                          statusColor = Colors.blueAccent;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Agendamento atualizado!'), backgroundColor: Colors.blueAccent),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF111934),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('SALVAR ALTERAÇÕES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void cancelarAgendamento() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Agendamento?'),
        content: const Text('Você tem certeza que deseja cancelar este agendamento?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Não')),
          TextButton(
            onPressed: () {
              setState(() {
                status = 'Cancelado';
                statusColor = const Color(0xFFB71C1C);
              });
              Navigator.pop(context);
            },
            child: const Text('Sim, cancelar', style: TextStyle(color: Colors.red)),
          ),
        ],
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
                      child: Image.asset('assets/logo.png', width: 100, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.white)),
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
                decoration: const BoxDecoration(color: Color(0xFFF1F1F1), borderRadius: BorderRadius.only(topLeft: Radius.circular(45))),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      const Align(alignment: Alignment.centerLeft, child: Text('Detalhes agendamento', style: TextStyle(fontSize: 18))),
                      const SizedBox(height: 20),

                      // CARD DE DETALHES
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(color: const Color(0xFF111934), borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: Text(local, style: const TextStyle(color: Colors.white, fontSize: 18))),
                            const SizedBox(height: 25),
                            Text('Data: $data', style: const TextStyle(color: Colors.white, fontSize: 16)),
                            const SizedBox(height: 10),
                            Text('Horário: $horario', style: const TextStyle(color: Colors.white, fontSize: 16)),
                            const SizedBox(height: 10),
                            Text('Endereço: $endereco', style: const TextStyle(color: Colors.white, fontSize: 16)),
                            const SizedBox(height: 25),
                            Align(alignment: Alignment.centerRight, child: Text(status, style: TextStyle(color: statusColor, fontSize: 16, fontWeight: FontWeight.bold))),
                            const SizedBox(height: 30),

                            // BOTÕES
                            Center(
                              child: Column(
                                children: [
                                  _buildActionButton('Remarcar', width: 280, onTap: status == 'Cancelado' ? null : abrirRemarcar),
                                  const SizedBox(height: 15),
                                  _buildActionButton('Cancelar', width: 280, onTap: status == 'Cancelado' ? null : cancelarAgendamento),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Text('Falar com a empresa', style: TextStyle(decoration: TextDecoration.underline, fontStyle: FontStyle.italic)),
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
        width: width, height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: onTap == null ? Colors.grey : const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(15)),
        child: Text(titulo, style: TextStyle(color: onTap == null ? Colors.white70 : Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

