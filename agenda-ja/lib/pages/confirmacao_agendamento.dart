import 'package:flutter/material.dart';

import '../models/agendamento.dart';
import '../models/profissional.dart';
import '../models/servico.dart';
import '../services/agendamento_service.dart';
import '../services/api_client.dart';
import '../utils/date_utils.dart';
import 'homecliente.dart';

class ConfirmacaoAgendamentoPage extends StatefulWidget {
  final Servico? servico;
  final Profissional? profissional;
  final HorarioLivre? horario;
  final Agendamento? agendamentoExistente;

  const ConfirmacaoAgendamentoPage({
    super.key,
    this.servico,
    this.profissional,
    this.horario,
    this.agendamentoExistente,
  });

  @override
  State<ConfirmacaoAgendamentoPage> createState() => _ConfirmacaoAgendamentoPageState();
}

class _ConfirmacaoAgendamentoPageState extends State<ConfirmacaoAgendamentoPage> {
  bool _carregando = false;
  Agendamento? _criado;

  Future<void> _confirmar() async {
    if (widget.servico == null || widget.profissional == null || widget.horario == null) return;

    setState(() => _carregando = true);
    try {
      final ag = await AgendamentoService.instance.criar(
        profissionalId: widget.profissional!.id,
        servicoId: widget.servico!.id,
        dataHoraInicio: widget.horario!.dataHoraInicio,
      );
      if (mounted) setState(() => _criado = ag);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final servico = widget.servico;
    final profissional = widget.profissional;
    final horario = widget.horario;
    final criado = _criado;

    if (servico == null || profissional == null || horario == null) {
      return const Scaffold(body: Center(child: Text('Dados incompletos para agendamento.')));
    }

    final inicio = DateTime.parse(horario.dataHoraInicio);

    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
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
                      child: Image.asset('assets/logo.png', width: 80,
                          errorBuilder: (_, __, ___) => const Icon(Icons.circle, color: Colors.white)),
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        criado != null ? 'Agendamento Confirmado' : 'Confirmar agendamento',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: criado != null ? Colors.green.shade700 : Colors.black87,
                        ),
                      ),
                      if (criado != null)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Icon(Icons.check_circle, color: Colors.green, size: 32),
                        ),
                      const SizedBox(height: 25),
                      _card('Serviço: ${servico.nome}\nProfissional: ${profissional.nome}'),
                      const SizedBox(height: 16),
                      _card('Data: ${formatarData(inicio)}\nHorário: ${formatarHora(inicio)}'),
                      const SizedBox(height: 16),
                      _card('Duração: ${servico.duracaoMinutos} min\nValor: R\$ ${servico.preco.toStringAsFixed(2)}'),
                      const SizedBox(height: 30),
                      if (criado == null)
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _carregando ? null : _confirmar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF111934),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _carregando
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Confirmar agendamento', style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        )
                      else ...[
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const HomeClientePage()),
                                (route) => route.isFirst,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF111934),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Ver minha agenda', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Você receberá uma confirmação via WhatsApp se o serviço estiver ativo.',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
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

  Widget _card(String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Text(content, style: const TextStyle(fontSize: 15, height: 1.5)),
    );
  }
}
