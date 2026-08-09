import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import '../services/disponibilidade_service.dart';
import '../utils/date_utils.dart';

class AgendaPage extends StatefulWidget {
  final String nomeEmpresa;
  final DateTime? initialDate;

  const AgendaPage({super.key, required this.nomeEmpresa, this.initialDate});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late DateTime _dataSelecionada;
  List<Agendamento> _agendamentosSemana = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    final inicial = widget.initialDate?.toLocal() ?? DateTime.now();
    _dataSelecionada = DateTime(inicial.year, inicial.month, inicial.day);
    _carregar();
  }

  DateTime _inicioSemana(DateTime data) {
    final limpa = DateTime(data.year, data.month, data.day);
    return limpa.subtract(Duration(days: limpa.weekday - DateTime.monday));
  }

  List<DateTime> get _diasDaSemana {
    final inicio = _inicioSemana(_dataSelecionada);
    return List.generate(7, (index) => inicio.add(Duration(days: index)));
  }

  List<Agendamento> get _agendamentosDoDia {
    return _agendamentosSemana.where((item) {
      final data = item.dataHoraInicio.toLocal();
      return data.year == _dataSelecionada.year &&
          data.month == _dataSelecionada.month &&
          data.day == _dataSelecionada.day;
    }).toList();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final inicio = _inicioSemana(_dataSelecionada);
      final fim = inicio.add(const Duration(days: 6));
      final agendamentos = await AgendamentoService.instance.listarAdmin(
        dataInicio: formatarDataIso(inicio),
        dataFim: formatarDataIso(fim),
      );
      if (mounted) setState(() => _agendamentosSemana = agendamentos);
    } catch (e) {
      if (mounted) setState(() => _erro = e.toString());
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (data != null) {
      setState(() => _dataSelecionada = data);
      await _carregar();
    }
  }

  Future<void> _mudarSemana(int quantidade) async {
    setState(() {
      _dataSelecionada = _dataSelecionada.add(Duration(days: 7 * quantidade));
    });
    await _carregar();
  }

  Future<void> _alterarStatus(Agendamento agendamento, String status) async {
    try {
      await AgendamentoService.instance.atualizarAdmin(
        agendamento.id,
        status: status,
      );
      await _carregar();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _cancelar(Agendamento agendamento) async {
    if (agendamento.isCancelado) return;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar agendamento?'),
        content: Text(
          '${agendamento.clienteNome ?? 'Cliente'} • '
          '${DateFormat('dd/MM/yyyy HH:mm').format(agendamento.dataHoraInicio.toLocal())}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Cancelar agendamento',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;
    await _alterarStatus(agendamento, 'cancelado');
    _mensagem('Agendamento cancelado.');
  }

  Future<void> _reagendar(Agendamento agendamento) async {
    final hoje = DateTime.now();
    final inicial = agendamento.dataHoraInicio.isAfter(hoje)
        ? agendamento.dataHoraInicio.toLocal()
        : hoje;
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime(inicial.year, inicial.month, inicial.day),
      firstDate: DateTime(hoje.year, hoje.month, hoje.day),
      lastDate: hoje.add(const Duration(days: 730)),
    );
    if (data == null || !mounted) return;
    try {
      final horarios = await DisponibilidadeService.instance.horariosLivres(
        profissionalId: agendamento.profissionalId,
        servicoId: agendamento.servicoId,
        data: formatarDataIso(data),
      );
      if (!mounted) return;
      if (horarios.isEmpty) {
        _mensagem('Nenhum horário disponível nessa data.');
        return;
      }
      final horario = await showDialog<HorarioLivre>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text('Horários em ${DateFormat('dd/MM/yyyy').format(data)}'),
          children: horarios
              .map(
                (item) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, item),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(item.horario),
                  ),
                ),
              )
              .toList(),
        ),
      );
      if (horario == null || !mounted) return;
      await AgendamentoService.instance.atualizarAdmin(
        agendamento.id,
        dataHoraInicio: horario.dataHoraInicio,
      );
      _mensagem('Agendamento reagendado com sucesso.');
      await _carregar();
    } catch (e) {
      _mensagem(e.toString());
    }
  }

  void _mensagem(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111934),
        foregroundColor: Colors.white,
        title: Text('Agenda • ${widget.nomeEmpresa}'),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
        ),
        child: Column(
          children: [
            _seletorSemana(),
            Expanded(child: _conteudo()),
          ],
        ),
      ),
    );
  }

  Widget _seletorSemana() {
    const nomes = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    final dias = _diasDaSemana;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Semana anterior',
                onPressed: () => _mudarSemana(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _selecionarData,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        const Text(
                          'Semana',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${DateFormat('dd/MM').format(dias.first)} – '
                          '${DateFormat('dd/MM/yyyy').format(dias.last)}',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Próxima semana',
                onPressed: () => _mudarSemana(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(dias.length, (index) {
              final dia = dias[index];
              final selecionado =
                  dia.year == _dataSelecionada.year &&
                  dia.month == _dataSelecionada.month &&
                  dia.day == _dataSelecionada.day;
              final quantidade = _agendamentosSemana.where((item) {
                final data = item.dataHoraInicio.toLocal();
                return !item.isCancelado &&
                    data.year == dia.year &&
                    data.month == dia.month &&
                    data.day == dia.day;
              }).length;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _dataSelecionada = dia),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: selecionado
                            ? const Color(0xFF2563EB)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            nomes[index],
                            style: TextStyle(
                              fontSize: 11,
                              color: selecionado
                                  ? Colors.white
                                  : Colors.black54,
                            ),
                          ),
                          Text(
                            DateFormat('dd').format(dia),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selecionado ? Colors.white : Colors.black,
                            ),
                          ),
                          if (quantidade > 0)
                            Container(
                              margin: const EdgeInsets.only(top: 3),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: selecionado
                                    ? Colors.white
                                    : const Color(0xFF2563EB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$quantidade',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: selecionado
                                      ? const Color(0xFF2563EB)
                                      : Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _conteudo() {
    if (_carregando) return const Center(child: CircularProgressIndicator());
    if (_erro != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_erro!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _carregar,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }
    final agendamentos = _agendamentosDoDia;
    if (agendamentos.isEmpty) {
      return Center(
        child: Text(
          'Nenhum agendamento em ${DateFormat('dd/MM/yyyy').format(_dataSelecionada)}.',
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: agendamentos.length,
        itemBuilder: (_, index) => _card(agendamentos[index]),
      ),
    );
  }

  Widget _card(Agendamento agendamento) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          child: Text(
            DateFormat('HH:mm').format(agendamento.dataHoraInicio.toLocal()),
          ),
        ),
        title: Text(agendamento.clienteNome ?? 'Cliente'),
        subtitle: Text(
          '${DateFormat('dd/MM/yyyy').format(agendamento.dataHoraInicio.toLocal())}\n'
          '${agendamento.servicoNome ?? 'Serviço'} • ${agendamento.profissionalNome ?? 'Profissional'}',
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          tooltip: 'Alterar status',
          onSelected: (acao) {
            if (acao == 'reagendar') {
              _reagendar(agendamento);
            } else if (acao == 'cancelar') {
              _cancelar(agendamento);
            } else {
              _alterarStatus(agendamento, acao);
            }
          },
          itemBuilder: (_) => [
            if (!agendamento.isCancelado)
              const PopupMenuItem(value: 'reagendar', child: Text('Reagendar')),
            const PopupMenuItem(value: 'pendente', child: Text('Pendente')),
            const PopupMenuItem(value: 'confirmado', child: Text('Confirmado')),
            if (!agendamento.isCancelado)
              const PopupMenuItem(
                value: 'cancelar',
                child: Text(
                  'Cancelar agendamento',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
          child: Chip(label: Text(agendamento.statusLabel)),
        ),
      ),
    );
  }
}
