import 'package:flutter/material.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import '../utils/date_utils.dart';
import 'detalhes_agendamento.dart';

class MeusAgendamentosPage extends StatefulWidget {
  const MeusAgendamentosPage({super.key});

  @override
  State<MeusAgendamentosPage> createState() => _MeusAgendamentosPageState();
}

class _MeusAgendamentosPageState extends State<MeusAgendamentosPage> {
  List<Agendamento> _agendamentos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    try {
      final ags = await AgendamentoService.instance.meusAgendamentos();
      if (mounted) setState(() => _agendamentos = ags);
    } catch (_) {
      if (mounted) setState(() => _agendamentos = []);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final futuros = _agendamentos.where((a) => a.isFuturo).toList();
    final passados = _agendamentos.where((a) => a.isPassado).toList();
    final cancelados = _agendamentos.where((a) => a.isCancelado).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            _navbar(context),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(45)),
                ),
                child: _carregando
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: _carregar,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Meus agendamentos', style: TextStyle(fontSize: 22)),
                              const SizedBox(height: 25),
                              if (futuros.isNotEmpty) ...[
                                secaoTitulo('Futuros:'),
                                ...futuros.map((a) => cardAgendamento(context, a)),
                              ],
                              if (passados.isNotEmpty) ...[
                                const SizedBox(height: 20),
                                secaoTitulo('Passados:'),
                                ...passados.map((a) => cardAgendamento(context, a)),
                              ],
                              if (cancelados.isNotEmpty) ...[
                                const SizedBox(height: 20),
                                const Text('Cancelados:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C))),
                                const SizedBox(height: 10),
                                ...cancelados.map((a) => cardAgendamento(context, a, isCancelado: true)),
                              ],
                              if (_agendamentos.isEmpty)
                                const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('Nenhum agendamento encontrado.'))),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navbar(BuildContext context) {
    return Container(
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
    );
  }

  Widget secaoTitulo(String titulo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(color: const Color(0xFF111934), borderRadius: BorderRadius.circular(20)),
      child: Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  Widget cardAgendamento(BuildContext context, Agendamento ag, {bool isCancelado = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isCancelado ? const Color(0xFFB71C1C) : const Color(0xFF111934),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('→ ${formatarData(ag.dataHoraInicio)}', style: const TextStyle(color: Colors.white, fontSize: 16)),
          Text('Serviço: ${ag.servicoNome ?? "-"}', style: const TextStyle(color: Colors.white, fontSize: 15)),
          Text('Profissional: ${ag.profissionalNome ?? "-"}', style: const TextStyle(color: Colors.white, fontSize: 15)),
          Text('Horário: ${formatarHora(ag.dataHoraInicio)}', style: const TextStyle(color: Colors.white, fontSize: 15)),
          if (!isCancelado)
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetalhesAgendamentoPage(agendamento: ag)),
                  );
                  _carregar();
                },
                child: const Text('Ver detalhes', style: TextStyle(color: Colors.white54, fontSize: 12, decoration: TextDecoration.underline)),
              ),
            ),
        ],
      ),
    );
  }
}
