import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'confirmacao_agendamento.dart';

import '../models/servico.dart';
import '../services/servico_service.dart';

class AgendarPage extends StatefulWidget {
  const AgendarPage({super.key});

  @override
  State<AgendarPage> createState() => _AgendarPageState();
}

class _AgendarPageState extends State<AgendarPage> {
  final TextEditingController _buscaController = TextEditingController();
  List<Servico> _servicos = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final servicos = await ServicoService.instance.listarAtivos();
      if (mounted) setState(() => _servicos = servicos);
    } catch (e) {
      if (mounted) setState(() => _erro = e.toString());
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  List<Servico> get servicosFiltrados {
    final busca = _buscaController.text.toLowerCase();
    if (busca.isEmpty) return _servicos;
    return _servicos.where((s) {
      return s.nome.toLowerCase().contains(busca) ||
          (s.descricao?.toLowerCase().contains(busca) ?? false);
    }).toList();
  }

  void _abrirSeletorAgendamento(Servico servico) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ModalAgendamento(servico: servico),
    );
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

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
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Escolha um serviço',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Barra de Busca do Wireframe
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          controller: _buscaController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: 'Buscar serviço',
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'Escolha um serviço',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: _carregando
                            ? const Center(child: CircularProgressIndicator())
                            : _erro != null
                                ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(_erro!, textAlign: TextAlign.center),
                                        const SizedBox(height: 12),
                                        ElevatedButton(onPressed: _carregar, child: const Text('Tentar novamente')),
                                      ],
                                    ),
                                  )
                                : servicosFiltrados.isEmpty
                                    ? const Center(child: Text('Nenhum serviço disponível.'))
                                    : ListView.builder(
                                        itemCount: servicosFiltrados.length,
                                        itemBuilder: (context, index) {
                                          final servico = servicosFiltrados[index];
                                          return _buildServicoCard(servico);
                                        },
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

  Widget _buildServicoCard(Servico servico) {
    return GestureDetector(
      onTap: () => _abrirSeletorAgendamento(servico),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.content_cut, color: Colors.black, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    servico.nome,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${servico.duracaoMinutos} min',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'R\$ ${servico.preco.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4285F4)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModalAgendamento extends StatefulWidget {
  final Servico servico;
  const _ModalAgendamento({required this.servico});

  @override
  State<_ModalAgendamento> createState() => _ModalAgendamentoState();
}

class _ModalAgendamentoState extends State<_ModalAgendamento> {
  DateTime _dataSelecionada = DateTime.now();
  String? _horaSelecionada;

  final List<String> _horarios = [
    '09:00', '10:00', '11:00', '13:00', '14:00', '15:00', '16:00', '17:00'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Agendar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Selecione a data:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final data = await showDatePicker(
                context: context,
                initialDate: _dataSelecionada,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 60)),
              );
              if (data != null) setState(() => _dataSelecionada = data);
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20, color: Color(0xFF4285F4)),
                  const SizedBox(width: 10),
                  Text(DateFormat('dd/MM/yyyy').format(_dataSelecionada)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Text('Selecione o horário:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _horarios.map((hora) {
              final isSelected = _horaSelecionada == hora;
              return GestureDetector(
                onTap: () => setState(() => _horaSelecionada = hora),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF4285F4) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected ? const Color(0xFF4285F4) : Colors.grey.shade300),
                  ),
                  child: Text(
                    hora,
                    style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _horaSelecionada == null
                  ? null
                  : () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConfirmacaoAgendamentoPage(),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285F4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Continuar', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
