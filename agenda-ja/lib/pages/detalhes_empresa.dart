import 'package:flutter/material.dart';

import '../models/agendamento.dart';
import '../models/profissional.dart';
import '../models/servico.dart';
import '../services/disponibilidade_service.dart';
import '../services/agendamento_service.dart';
import '../services/api_client.dart';
import '../services/profissional_service.dart';
import '../utils/date_utils.dart';
import 'confirmacao_agendamento.dart';

class AgendamentoEmpresaDetalhesPage extends StatefulWidget {
  final Servico? servico;

  const AgendamentoEmpresaDetalhesPage({super.key, this.servico});

  @override
  State<AgendamentoEmpresaDetalhesPage> createState() =>
      _AgendamentoEmpresaDetalhesPageState();
}

class _AgendamentoEmpresaDetalhesPageState
    extends State<AgendamentoEmpresaDetalhesPage> {
  late Servico _servico;
  List<Profissional> _profissionais = [];
  Profissional? _profissionalSelecionado;
  List<HorarioLivre> _horarios = [];
  HorarioLivre? _horarioSelecionado;

  DateTime _mesAtual = DateTime(DateTime.now().year, DateTime.now().month);
  int? _diaSelecionado;

  bool _carregandoProf = true;
  bool _carregandoHorarios = false;
  bool _confirmando = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _diaSelecionado = DateTime.now().day;
    if (widget.servico != null) {
      _servico = widget.servico!;
      _carregarProfissionais();
    }
  }

  Future<void> _carregarProfissionais() async {
    setState(() {
      _carregandoProf = true;
      _erro = null;
    });
    try {
      final profs = await ProfissionalService.instance.listarPorServico(
        _servico.id,
      );
      if (mounted) {
        setState(() {
          _profissionais = profs;
          if (profs.isNotEmpty) _profissionalSelecionado = profs.first;
        });
        await _carregarHorarios();
      }
    } catch (e) {
      if (mounted) setState(() => _erro = e.toString());
    } finally {
      if (mounted) setState(() => _carregandoProf = false);
    }
  }

  Future<void> _carregarHorarios() async {
    final prof = _profissionalSelecionado;
    final dia = _diaSelecionado;
    if (prof == null || dia == null) return;

    setState(() {
      _carregandoHorarios = true;
      _horarioSelecionado = null;
    });

    try {
      final data = DateTime(_mesAtual.year, _mesAtual.month, dia);
      final horarios = await DisponibilidadeService.instance.horariosLivres(
        profissionalId: prof.id,
        servicoId: _servico.id,
        data: formatarDataIso(data),
      );
      if (mounted) setState(() => _horarios = horarios);
    } catch (e) {
      if (mounted) setState(() => _horarios = []);
    } finally {
      if (mounted) setState(() => _carregandoHorarios = false);
    }
  }

  Future<void> _confirmar() async {
    final profissional = _profissionalSelecionado;
    final horario = _horarioSelecionado;
    if (profissional == null || horario == null || _confirmando) return;

    setState(() => _confirmando = true);
    try {
      final agendamento = await AgendamentoService.instance.criar(
        profissionalId: profissional.id,
        servicoId: _servico.id,
        dataHoraInicio: horario.dataHoraInicio,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmacaoAgendamentoPage(agendamento: agendamento),
        ),
      );
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
        );
        await _carregarHorarios();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível concluir o agendamento.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _confirmando = false);
    }
  }

  int _diasDoMes() => DateTime(_mesAtual.year, _mesAtual.month + 1, 0).day;

  int _primeiroDiaMes() =>
      DateTime(_mesAtual.year, _mesAtual.month, 1).weekday % 7;

  static const _meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.servico == null) {
      return const Scaffold(
        body: Center(child: Text('Serviço não informado.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              color: const Color(0xFF111934),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png',
                        width: 100,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(45)),
                ),
                child: _carregandoProf
                    ? const Center(child: CircularProgressIndicator())
                    : _erro != null
                    ? Center(child: Text(_erro!))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  Text(
                                    _servico.nome,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  if (_servico.descricao != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      _servico.descricao!,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Text(
                                    'Duração: ${_servico.duracaoMinutos} min • R\$ ${_servico.preco.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Profissional:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<Profissional>(
                              value: _profissionalSelecionado,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: _profissionais
                                  .map(
                                    (p) => DropdownMenuItem(
                                      value: p,
                                      child: Text(p.nome),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (p) {
                                setState(() => _profissionalSelecionado = p);
                                _carregarHorarios();
                              },
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(
                                            () => _mesAtual = DateTime(
                                              _mesAtual.year,
                                              _mesAtual.month - 1,
                                            ),
                                          );
                                          _carregarHorarios();
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                          size: 18,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF111934),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          _meses[_mesAtual.month - 1],
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(
                                            () => _mesAtual = DateTime(
                                              _mesAtual.year,
                                              _mesAtual.month + 1,
                                            ),
                                          );
                                          _carregarHorarios();
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: _diasDoMes() + _primeiroDiaMes(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 7,
                                        ),
                                    itemBuilder: (context, index) {
                                      if (index < _primeiroDiaMes())
                                        return const SizedBox();
                                      final dia = index - _primeiroDiaMes() + 1;
                                      final dataDia = DateTime(
                                        _mesAtual.year,
                                        _mesAtual.month,
                                        dia,
                                      );
                                      final hoje = DateTime.now();
                                      final hojeLimpo = DateTime(
                                        hoje.year,
                                        hoje.month,
                                        hoje.day,
                                      );
                                      final noPassado = dataDia.isBefore(
                                        hojeLimpo,
                                      );
                                      final selecionado =
                                          dia == _diaSelecionado;
                                      return GestureDetector(
                                        onTap: noPassado
                                            ? null
                                            : () {
                                                setState(
                                                  () => _diaSelecionado = dia,
                                                );
                                                _carregarHorarios();
                                              },
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: selecionado
                                                ? const Color(0xFF111934)
                                                : Colors.transparent,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '$dia',
                                            style: TextStyle(
                                              color: noPassado
                                                  ? Colors.grey
                                                  : (selecionado
                                                        ? Colors.white
                                                        : Colors.black),
                                              fontWeight: selecionado
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Horários disponíveis:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            if (_carregandoHorarios)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            else if (_horarios.isEmpty)
                              const Text(
                                'Nenhum horário disponível nesta data.',
                              )
                            else
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: _horarios.map((h) {
                                  final sel =
                                      _horarioSelecionado?.horario == h.horario;
                                  return GestureDetector(
                                    onTap: () =>
                                        setState(() => _horarioSelecionado = h),
                                    child: Container(
                                      width: 80,
                                      height: 35,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: sel
                                            ? Colors.green
                                            : const Color(0xFFD9D9D9),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        h.horario,
                                        style: TextStyle(
                                          color: sel
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 25),
                            Center(
                              child: SizedBox(
                                width: 220,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed:
                                      _horarioSelecionado == null ||
                                          _profissionalSelecionado == null ||
                                          _confirmando
                                      ? null
                                      : _confirmar,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: _confirmando
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Confirmar horário',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
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
}
