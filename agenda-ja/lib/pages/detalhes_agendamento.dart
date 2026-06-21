import 'package:flutter/material.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import '../services/api_client.dart';
import '../utils/date_utils.dart';

class DetalhesAgendamentoPage extends StatefulWidget {
  final Agendamento agendamento;

  const DetalhesAgendamentoPage({super.key, required this.agendamento});

  @override
  State<DetalhesAgendamentoPage> createState() => _DetalhesAgendamentoPageState();
}

class _DetalhesAgendamentoPageState extends State<DetalhesAgendamentoPage> {
  late Agendamento _ag;
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _ag = widget.agendamento;
  }

  Color get statusColor {
    switch (_ag.status) {
      case 'confirmado':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Future<void> _cancelar() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar Agendamento'),
        content: const Text('Tem certeza que deseja cancelar este compromisso?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Não')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sim, cancelar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _carregando = true);
    try {
      final atualizado = await AgendamentoService.instance.cancelar(_ag.id);
      if (mounted) setState(() => _ag = atualizado);
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
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30)),
                  Expanded(child: Center(child: Image.asset('assets/logo.png', width: 100, errorBuilder: (_, __, ___) => const Icon(Icons.image, color: Colors.white)))),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xFFF1F1F1), borderRadius: BorderRadius.only(topLeft: Radius.circular(45))),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(color: const Color(0xFF111934), borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Detalhes agendamento', style: TextStyle(color: Colors.white54)),
                            const SizedBox(height: 15),
                            Center(
                              child: Text(
                                _ag.servicoNome ?? 'Serviço',
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text('Profissional: ${_ag.profissionalNome ?? "-"}', style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 10),
                            Text('Data: ${formatarData(_ag.dataHoraInicio)}', style: const TextStyle(color: Colors.white)),
                            Text('Horário: ${formatarHora(_ag.dataHoraInicio)}', style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(statusLabel(_ag.status), style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                            ),
                            if (!_ag.isCancelado && _ag.isFuturo) ...[
                              const SizedBox(height: 30),
                              Center(
                                child: SizedBox(
                                  width: 200,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: _carregando ? null : _cancelar,
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900),
                                    child: _carregando
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : const Text('Cancelar', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ],
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
}
