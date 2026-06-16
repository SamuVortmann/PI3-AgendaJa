import 'package:flutter/material.dart';
import 'dados_globais.dart';

class DetalhesAgendamentoPage extends StatefulWidget {
  final String? agendamentoId;

  const DetalhesAgendamentoPage({super.key, this.agendamentoId});

  @override
  State<DetalhesAgendamentoPage> createState() => _DetalhesAgendamentoPageState();
}

class _DetalhesAgendamentoPageState extends State<DetalhesAgendamentoPage> {
  // Dados locais (Simulando carregamento do banco pelo ID)
  String local = 'Clinica Tesser - Concórdia';
  String dataExibicao = '10/06/2026';
  String horarioExibicao = '16:50';
  String endereco = 'Rua Prefeito Domingos Machado de Lima, 755 - Centro, Concórdia - SC, 89700-075';
  String status = 'Confirmado';
  Color statusColor = Colors.green;

  // Variáveis para o Calendário de Remarcação
  DateTime mesAtual = DateTime(2026, 6);
  DateTime? dataSelecionada;
  String? horarioSelecionado;

  final List<String> horariosDisponiveis = ['08:00', '09:00', '10:00', '11:00', '14:00', '15:00', '16:00', '17:00'];

  void abrirCalendarioRemarcar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Color(0xFFF3F3F3),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              const Text('Selecione a nova data e horário', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              // CALENDÁRIO
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: () => setModalState(() => mesAtual = DateTime(mesAtual.year, mesAtual.month - 1)), icon: const Icon(Icons.arrow_back_ios, size: 16)),
                          Text('${mesAtual.month}/2026', style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(onPressed: () => setModalState(() => mesAtual = DateTime(mesAtual.year, mesAtual.month + 1)), icon: const Icon(Icons.arrow_forward_ios, size: 16)),
                        ],
                      ),
                      const Divider(),
                      // Dias da semana e Grid do calendário (Simplificado para o exemplo)
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                        itemCount: 30,
                        itemBuilder: (context, index) {
                          int dia = index + 1;
                          bool isSel = dataSelecionada?.day == dia && dataSelecionada?.month == mesAtual.month;
                          return GestureDetector(
                            onTap: () => setModalState(() => dataSelecionada = DateTime(mesAtual.year, mesAtual.month, dia)),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: isSel ? const Color(0xFF111934) : Colors.transparent, shape: BoxShape.circle),
                              child: Text('$dia', style: TextStyle(color: isSel ? Colors.white : Colors.black)),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              const Text('Horários disponíveis:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              // HORÁRIOS
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: horariosDisponiveis.map((h) {
                  bool isSel = horarioSelecionado == h;
                  return GestureDetector(
                    onTap: () => setModalState(() => horarioSelecionado = h),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(color: isSel ? const Color(0xFF111934) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)),
                      child: Text(h, style: TextStyle(color: isSel ? Colors.white : Colors.black)),
                    ),
                  );
                }).toList(),
              ),
              
              const Spacer(),
              
              // BOTÃO SALVAR
              Padding(
                padding: const EdgeInsets.all(30),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (dataSelecionada != null && horarioSelecionado != null) ? () {
                      setState(() {
                        dataExibicao = '${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}';
                        horarioExibicao = horarioSelecionado!;
                        status = 'Remarcado';
                        statusColor = Colors.blue;
                      });
                      
                      // Atualiza nos DadosGlobais (Opcional: implementar lógica de persistência aqui)
                      
                      Navigator.pop(context);
                    } : null,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF111934), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    child: const Text('SALVAR ALTERAÇÕES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void cancelarCompromisso() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Agendamento'),
        content: const Text('Tem certeza que deseja cancelar este compromisso?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Não')),
          TextButton(
            onPressed: () {
              if (widget.agendamentoId != null) {
                DadosGlobais.cancelarAgendamento(widget.agendamentoId!);
              }
              setState(() { status = 'Cancelado'; statusColor = Colors.red; });
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
              width: double.infinity, height: 80, padding: const EdgeInsets.symmetric(horizontal: 18), color: const Color(0xFF111934),
              child: Row(
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30)),
                  Expanded(child: Center(child: Image.asset('assets/logo.png', width: 100, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.white)))),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            // CONTEÚDO
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xFFF1F1F1), borderRadius: BorderRadius.only(topLeft: Radius.circular(45))),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity, padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(color: const Color(0xFF111934), borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Detalhes agendamento', style: TextStyle(color: Colors.white54, fontSize: 14)),
                            const SizedBox(height: 15),
                            Center(child: Text(local, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                            const SizedBox(height: 20),
                            Text('Data: $dataExibicao', style: const TextStyle(color: Colors.white, fontSize: 16)),
                            const SizedBox(height: 10),
                            Text('Horário: $horarioExibicao', style: const TextStyle(color: Colors.white, fontSize: 16)),
                            const SizedBox(height: 10),
                            Text('Endereço: $endereco', style: const TextStyle(color: Colors.white, fontSize: 14)),
                            const SizedBox(height: 20),
                            Align(alignment: Alignment.centerRight, child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 16))),
                            const SizedBox(height: 30),
                            Center(
                              child: Column(
                                children: [
                                  _buildButton('Remarcar', Colors.white, Colors.black, onTap: abrirCalendarioRemarcar),
                                  const SizedBox(height: 12),
                                  _buildButton('Cancelar', Colors.white, Colors.black, onTap: cancelarCompromisso),
                                ],
                              ),
                            ),
                          ],
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

  Widget _buildButton(String label, Color bg, Color text, {VoidCallback? onTap}) {
    return SizedBox(
      width: 200, height: 40,
      child: ElevatedButton(
        onPressed: onTap ?? () {},
        style: ElevatedButton.styleFrom(backgroundColor: bg, foregroundColor: text, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: Text(label),
      ),
    );
  }
}
