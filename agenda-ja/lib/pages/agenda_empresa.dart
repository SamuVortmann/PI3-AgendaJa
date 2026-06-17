import 'package:flutter/material.dart';
import 'dados_globais.dart';

class AgendaPage extends StatefulWidget {
  final String nomeEmpresa;

  const AgendaPage({super.key, required this.nomeEmpresa});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DateTime dataSelecionada = DateTime(2026, 5, 28);
  DateTime mesAtual = DateTime(2026, 5);

  void proximoMes() {
    if (mesAtual.year < 2027 || mesAtual.month < 12) {
      setState(() {
        mesAtual = DateTime(mesAtual.year, mesAtual.month + 1);
      });
    }
  }

  void mesAnterior() {
    if (mesAtual.year > 2026 || mesAtual.month > 5) {
      setState(() {
        mesAtual = DateTime(mesAtual.year, mesAtual.month - 1);
      });
    }
  }

  String getNomeMes(int mes) {
    const meses = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];
    return meses[mes - 1];
  }

  @override
  Widget build(BuildContext context) {
    // BUSCA DINÂMICA NO DADOS GLOBAIS
    String keyData =
        "${dataSelecionada.year}-${dataSelecionada.month.toString().padLeft(2, '0')}-${dataSelecionada.day.toString().padLeft(2, '0')}";
    List<Map<String, String>> agendamentosDoDia =
        DadosGlobais.getAgendamentosPorData(keyData);

    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO
            Container(
              width: double.infinity,
              height: 80,
              color: const Color(0xFF111934),
              child: Stack(
                children: [
                  Positioned(
                    top: 15,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () => Navigator.pop(context),
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
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'Agenda Já',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // CORPO
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, ${widget.nomeEmpresa} !',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 25),
                      // CALENDÁRIO
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Sua agenda  ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                GestureDetector(
                                  onTap: mesAnterior,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    color: const Color(0xFF111934),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 4,
                                  ),
                                  color: const Color(0xFF111934),
                                  child: Text(
                                    getNomeMes(mesAtual.month),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: proximoMes,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    color: const Color(0xFF111934),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                Text('D'),
                                Text('S'),
                                Text('T'),
                                Text('Q'),
                                Text('Q'),
                                Text('S'),
                                Text('S'),
                              ],
                            ),
                            const Divider(),
                            buildDiasCalendario(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // LISTA DE AGENDAMENTOS
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111934),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Agendamentos do dia',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 15),
                            if (agendamentosDoDia.isEmpty)
                              const Center(
                                child: Text(
                                  'Nenhum agendamento',
                                  style: TextStyle(color: Colors.white54),
                                ),
                              )
                            else
                              ...agendamentosDoDia
                                  .map(
                                    (ag) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${ag['horario']} - ${ag['nome']}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => mostrarDetalhes(ag),
                                            child: const Text(
                                              'Detalhes',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontStyle: FontStyle.italic,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
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

  Widget buildDiasCalendario() {
    int diasNoMes = DateTime(mesAtual.year, mesAtual.month + 1, 0).day;
    int primeiroDiaSemana =
        DateTime(mesAtual.year, mesAtual.month, 1).weekday % 7;

    List<Widget> dias = [];
    for (int i = 0; i < primeiroDiaSemana; i++)
      dias.add(const SizedBox(width: 35, height: 35));

    for (int i = 1; i <= diasNoMes; i++) {
      bool selecionado =
          dataSelecionada.day == i &&
          dataSelecionada.month == mesAtual.month &&
          dataSelecionada.year == mesAtual.year;
      dias.add(
        GestureDetector(
          onTap: () => setState(
            () => dataSelecionada = DateTime(mesAtual.year, mesAtual.month, i),
          ),
          child: Container(
            width: 35,
            height: 35,
            alignment: Alignment.center,
            decoration: selecionado
                ? const BoxDecoration(
                    color: Color(0xFF111934),
                    shape: BoxShape.circle,
                  )
                : null,
            child: Text(
              i.toString().padLeft(2, '0'),
              style: TextStyle(
                color: selecionado ? Colors.white : Colors.black,
                fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(spacing: 5, runSpacing: 5, children: dias);
  }

  // MODAL DE DETALHES UNIFICADO (COM HISTÓRICO)
  void mostrarDetalhes(Map<String, String> ag) {
    final nome = ag['nome']!;
    final ultimo = DadosGlobais.getUltimoAtendimento(nome);
    final proximo = DadosGlobais.getProximoAtendimento(nome);
    final cancelados = DadosGlobais.getCancelados(nome);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Color(0xFFF3F3F3),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Detalhes agendamento',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // CARD PRINCIPAL DO AGENDAMENTO ATUAL
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF111934),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        nome,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Data: ${dataSelecionada.day}/${dataSelecionada.month}/${dataSelecionada.year}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Horário: ${ag['horario']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Telefone: ${ag['telefone']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _botaoAcaoModal('Confirmar', Colors.green),
                        _botaoAcaoModal('Cancelar', Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // HISTÓRICO INTEGRADO (O QUE VOCÊ PEDIU)
              const Text(
                'Histórico do cliente:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildHistoricoCard(
                'Último atendimento',
                ultimo?['data'] ?? '--',
                ultimo?['horario'] ?? '--',
              ),
              const SizedBox(height: 10),
              _buildHistoricoCard(
                'Próximo atendimento',
                proximo?['data'] ?? '--',
                proximo?['horario'] ?? '--',
              ),
              if (cancelados.isNotEmpty) ...[
                const SizedBox(height: 10),
                _buildHistoricoCard(
                  'Cancelado',
                  cancelados.first['data']!,
                  cancelados.first['horario']!,
                  cor: Colors.red.shade100,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _botaoAcaoModal(String texto, Color cor) {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: cor,
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      child: Text(
        texto,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildHistoricoCard(
    String titulo,
    String data,
    String hora, {
    Color cor = Colors.white,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Dia: $data'),
          Text('Horário: $hora'),
        ],
      ),
    );
  }
}
