import 'package:flutter/material.dart';

class ConfirmacaoAgendamentoPage extends StatefulWidget {
  const ConfirmacaoAgendamentoPage({super.key});

  @override
  State<ConfirmacaoAgendamentoPage> createState() => _ConfirmacaoAgendamentoPageState();
}

class _ConfirmacaoAgendamentoPageState extends State<ConfirmacaoAgendamentoPage> {
  String _status = 'pendente'; 
  DateTime _dataSelecionada = DateTime.now();
  String _horarioSelecionado = "16:00";
  bool _editando = false;

  // Lógica do Calendário Customizado
  int _mesAtualIndex = DateTime.now().month - 1;
  final List<String> _mesesNomes = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  final List<String> _horariosDisponiveis = [
    "08:00", "09:00", "10:00", "11:00", "13:00", "14:00", "15:00", "16:00", "17:00"
  ];

  int _diasDoMes(int mes, int ano) {
    return DateTime(ano, mes + 1, 0).day;
  }

  int _primeiroDiaMes(int mes, int ano) {
    return DateTime(ano, mes, 1).weekday % 7;
  }

  void _abrirCalendario() {
    setState(() {
      _editando = true;
      _status = 'pendente';
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String>? empresa = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final String nome = empresa?['nome'] ?? 'Prado Concept';
    final String endereco = empresa?['endereco'] ?? 'Rua Leonidas Favero, 261 - Loja 02\nBairro Jardim, Concórdia';

    String dataFormatada = "${_dataSelecionada.day.toString().padLeft(2, '0')}/${_dataSelecionada.month.toString().padLeft(2, '0')}";

    // Configurações de Status
    String titulo = 'Confirmar agendamento';
    Color corTitulo = Colors.black87;
    IconData? iconeStatus;
    Color? corIcone;

    if (_status == 'confirmado') {
      titulo = 'Agendamento Confirmado';
      corTitulo = Colors.green[700]!;
      iconeStatus = Icons.check_circle;
      corIcone = Colors.green;
    } else if (_status == 'cancelado') {
      titulo = 'Agendamento Cancelado';
      corTitulo = Colors.red[800]!;
      iconeStatus = Icons.cancel;
      corIcone = Colors.red;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png',
                        width: 80,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.circle, color: Colors.white),
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            titulo,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: corTitulo,
                            ),
                          ),
                          if (iconeStatus != null)
                            Icon(iconeStatus, color: corIcone, size: 28),
                        ],
                      ),
                      const SizedBox(height: 25),

                      if (!_editando) ...[
                        // VISUALIZAÇÃO DOS DETALHES
                        _buildInfoCard(content: 'local : $nome\nServiço : Corte de cabelo'),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _status == 'confirmado' ? null : _abrirCalendario,
                          child: _buildInfoCard(
                            content: 'Data : $dataFormatada\nHorário : $_horarioSelecionado',
                            trailing: _status == 'confirmado' ? null : const Icon(Icons.edit_calendar, size: 20, color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildInfoCard(content: 'Endereço: $endereco'),
                        const SizedBox(height: 40),
                      ] else ...[
                        // INTERFACE DE EDIÇÃO (CALENDÁRIO CUSTOMIZADO)
                        const Text("Selecione a nova data:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        _buildCustomCalendar(),
                        const SizedBox(height: 25),
                        const Text("Selecione o horário:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        _buildTimeGrid(),
                        const SizedBox(height: 30),
                        _buildButton(
                          text: 'Salvar Alterações',
                          onPressed: () => setState(() => _editando = false),
                        ),
                        const SizedBox(height: 10),
                      ],

                      // BOTÕES DE AÇÃO
                      if (!_editando) ...[
                        if (_status == 'pendente') ...[
                          _buildButton(
                            text: 'Confirmar agendamento',
                            onPressed: () => setState(() => _status = 'confirmado'),
                          ),
                          const SizedBox(height: 15),
                          _buildButton(
                            text: 'Editar Data/Hora',
                            onPressed: _abrirCalendario,
                          ),
                        ] else if (_status == 'confirmado') ...[
                          _buildButton(
                            text: 'Cancelar Agendamento',
                            color: Colors.red[900],
                            onPressed: () => setState(() => _status = 'cancelado'),
                          ),
                          const SizedBox(height: 15),
                          _buildButton(
                            text: 'Voltar ao Início',
                            onPressed: () => Navigator.pop(context),
                          ),
                        ] else if (_status == 'cancelado') ...[
                          _buildButton(
                            text: 'Tentar Novamente',
                            onPressed: () => setState(() => _status = 'pendente'),
                          ),
                          const SizedBox(height: 15),
                          _buildButton(
                            text: 'Voltar ao Início',
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ],
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

  Widget _buildCustomCalendar() {
    int dias = _diasDoMes(_mesAtualIndex + 1, _dataSelecionada.year);
    int primeiroDia = _primeiroDiaMes(_mesAtualIndex + 1, _dataSelecionada.year);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF06153D)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => setState(() { if (_mesAtualIndex > 0) _mesAtualIndex--; }),
                icon: const Icon(Icons.arrow_back_ios, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF111934),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(_mesesNomes[_mesAtualIndex], style: const TextStyle(color: Colors.white)),
              ),
              IconButton(
                onPressed: () => setState(() { if (_mesAtualIndex < 11) _mesAtualIndex++; }),
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('D'), Text('S'), Text('T'), Text('Q'), Text('Q'), Text('S'), Text('S'),
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dias + primeiroDia,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
            itemBuilder: (context, index) {
              if (index < primeiroDia) return const SizedBox();
              int dia = index - primeiroDia + 1;
              bool selecionado = _dataSelecionada.day == dia && _dataSelecionada.month == (_mesAtualIndex + 1);
              
              return GestureDetector(
                onTap: () => setState(() {
                  _dataSelecionada = DateTime(_dataSelecionada.year, _mesAtualIndex + 1, dia);
                }),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selecionado ? const Color(0xFF111934) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$dia',
                    style: TextStyle(
                      color: selecionado ? Colors.white : Colors.black,
                      fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _horariosDisponiveis.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        String hora = _horariosDisponiveis[index];
        bool selecionado = _horarioSelecionado == hora;
        return GestureDetector(
          onTap: () => setState(() => _horarioSelecionado = hora),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selecionado ? const Color(0xFF111934) : Colors.white,
              border: Border.all(color: const Color(0xFF111934)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              hora,
              style: TextStyle(
                color: selecionado ? Colors.white : Colors.black,
                fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard({required String content, Widget? trailing}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: Text(content, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4))),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed, Color? color}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFF111934),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
