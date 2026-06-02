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
      setState(() => mesAtual = DateTime(mesAtual.year, mesAtual.month + 1));
    }
  }

  void mesAnterior() {
    if (mesAtual.year > 2026 || mesAtual.month > 5) {
      setState(() => mesAtual = DateTime(mesAtual.year, mesAtual.month - 1));
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
    String keyData =
        "${dataSelecionada.year}-${dataSelecionada.month.toString().padLeft(2, '0')}-${dataSelecionada.day.toString().padLeft(2, '0')}";
    List<Map<String, String>> agendamentosDoDia =
        DadosGlobais.getAgendamentosPorData(keyData);

    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
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
                                IconButton(
                                  icon: const Icon(Icons.arrow_back, size: 16),
                                  onPressed: mesAnterior,
                                  color: Colors.white,
                                  style: IconButton.styleFrom(
                                    backgroundColor: const Color(0xFF111934),
                                    shape: const RoundedRectangleBorder(),
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
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                    size: 16,
                                  ),
                                  onPressed: proximoMes,
                                  color: Colors.white,
                                  style: IconButton.styleFrom(
                                    backgroundColor: const Color(0xFF111934),
                                    shape: const RoundedRectangleBorder(),
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
      String diaKey =
          "${mesAtual.year}-${mesAtual.month.toString().padLeft(2, '0')}-${i.toString().padLeft(2, '0')}";
      bool temAgendamento = DadosGlobais.agendamentos.containsKey(diaKey);
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
                : (temAgendamento
                      ? BoxDecoration(
                          border: Border.all(color: const Color(0xFF111934)),
                          shape: BoxShape.circle,
                        )
                      : null),
            child: Text(
              i.toString().padLeft(2, '0'),
              style: TextStyle(
                color: selecionado ? Colors.white : Colors.black,
                fontWeight: (selecionado || temAgendamento)
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }
    return Wrap(spacing: 5, runSpacing: 5, children: dias);
  }

  void mostrarDetalhes(Map<String, String> ag) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 500,
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          color: Color(0xFFF3F3F3),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalhes agendamento',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
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
                  Center(
                    child: Text(
                      ag['nome']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Data: ${dataSelecionada.day}/${dataSelecionada.month}/${dataSelecionada.year}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Horário: ${ag['horario']}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Telefone: ${ag['telefone']}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Pendente',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 30),
                  botaoModal(
                    'Confirmar',
                    Colors.green,
                    () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),
                  botaoModal(
                    'Cancelar',
                    Colors.red,
                    () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),
                  botaoModal(
                    'Atendimento concluído',
                    Colors.grey,
                    () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget botaoModal(String texto, Color cor, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(texto, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
