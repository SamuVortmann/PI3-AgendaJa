import 'package:flutter/material.dart';
import 'dados_globais.dart';

class DetalhesAgendamentoPage extends StatefulWidget {
  final String? agendamentoId;

  const DetalhesAgendamentoPage({super.key, this.agendamentoId});

  @override
  State<DetalhesAgendamentoPage> createState() => _DetalhesAgendamentoPageState();
}

class _DetalhesAgendamentoPageState extends State<DetalhesAgendamentoPage> {
  // Dados locais
  late String local;
  late String dataExibicao;
  late String horarioExibicao;
  String endereco = 'Rua Prefeito Domingos Machado de Lima, 755 - Centro, Concórdia - SC, 89700-075';
  late String status;
  late Color statusColor;

  @override
  void initState() {
    super.initState();
    // Busca os dados atuais na prancheta ao abrir a tela
    final ag = DadosGlobais.meusAgendamentosCliente.firstWhere(
      (element) => element['id'] == widget.agendamentoId,
      orElse: () => DadosGlobais.meusAgendamentosCliente[0],
    );
    local = ag['local'];
    dataExibicao = ag['data'];
    horarioExibicao = ag['horario'];
    status = ag['status'];
    statusColor = status == 'Cancelado' ? Colors.red : (status == 'Remarcado' ? Colors.blue : Colors.green);
  }

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
          height: MediaQuery.of(context).size.height * 0.9,
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
              const SizedBox(height: 10),
              
              // CONTEÚDO COM SCROLL PARA EVITAR OVERFLOW
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // CALENDÁRIO
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(onPressed: () => setModalState(() => mesAtual = DateTime(mesAtual.year, mesAtual.month - 1)), icon: const Icon(Icons.arrow_back_ios, size: 16)),
                                Text('${mesAtual.month}/${mesAtual.year}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(onPressed: () => setModalState(() => mesAtual = DateTime(mesAtual.year, mesAtual.month + 1)), icon: const Icon(Icons.arrow_forward_ios, size: 16)),
                              ],
                            ),
                            const Divider(),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
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
                      
                      const SizedBox(height: 20),
                      const Text('Horários disponíveis:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      
                      // HORÁRIOS EM GRID
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 2.2,
                        ),
                        itemCount: horariosDisponiveis.length,
                        itemBuilder: (context, index) {
                          String h = horariosDisponiveis[index];
                          bool isSel = horarioSelecionado == h;
                          return GestureDetector(
                            onTap: () => setModalState(() => horarioSelecionado = h),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSel ? const Color(0xFF111934) : Colors.white, 
                                borderRadius: BorderRadius.circular(15), 
                                border: Border.all(color: Colors.grey.shade300)
                              ),
                              child: Text(h, style: TextStyle(color: isSel ? Colors.white : Colors.black, fontSize: 13)),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // BOTÃO SALVAR
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (dataSelecionada != null && horarioSelecionado != null) ? () {
                            String novaData = '${dataSelecionada!.day.toString().padLeft(2, '0')}/${dataSelecionada!.month.toString().padLeft(2, '0')}/${dataSelecionada!.year}';
                            String novoHorario = horarioSelecionado!;

                            // SALVAMENTO REAL NOS DADOS GLOBAIS
                            if (widget.agendamentoId != null) {
                              DadosGlobais.remarcarAgendamento(widget.agendamentoId!, novaData, novoHorario);
                            }

                            setState(() {
                              dataExibicao = novaData;
                              horarioExibicao = novoHorario;
                              status = 'Remarcado';
                              statusColor = Colors.blue;
                            });
                            
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agendamento remarcado com sucesso!')));
                          } : null,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF111934), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                          child: const Text('SALVAR ALTERAÇÕES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
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
