import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/agendamento.dart';
import 'meus-agendamentos.dart';

class ConfirmacaoAgendamentoPage extends StatefulWidget {
  final Agendamento agendamento;

  const ConfirmacaoAgendamentoPage({super.key, required this.agendamento});

  @override
  State<ConfirmacaoAgendamentoPage> createState() =>
      _ConfirmacaoAgendamentoPageState();
}

class _ConfirmacaoAgendamentoPageState
    extends State<ConfirmacaoAgendamentoPage> {
  String get _servicoNome => widget.agendamento.servicoNome ?? 'Serviço';
  String get _profissionalNome =>
      widget.agendamento.profissionalNome ?? 'Profissional';
  DateTime get _dataAgendamento => widget.agendamento.dataHoraInicio;
  String get _horaAgendamento =>
      DateFormat('HH:mm').format(_dataAgendamento.toLocal());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            // Header mantendo o estilo original
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, bottom: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Sucesso',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 40,
                  ),
                  child: _buildSucessoView(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSucessoView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Color(0xFF2ECC71),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 60),
        ),
        const SizedBox(height: 30),
        const Text(
          'Agendamento confirmado!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Você receberá um lembrete via WhatsApp antes do horário',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 40),
        _buildDetalhesCard(_dataAgendamento, _horaAgendamento, isSuccess: true),
        const SizedBox(height: 50),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MeusAgendamentosPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4285F4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Ver meus agendamentos',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetalhesCard(
    DateTime data,
    String hora, {
    bool isSuccess = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _servicoNome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'com $_profissionalNome',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              if (isSuccess)
                Container(
                  width: 60,
                  height: 25,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ECC71),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.access_time, size: 20, color: Colors.black54),
              const SizedBox(width: 10),
              Text(
                '${DateFormat('dd/MM/yyyy').format(data)} · $hora',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
