import 'package:flutter/material.dart';

import '../models/profissional.dart';
import '../models/servico.dart';
import '../services/disponibilidade_service.dart';
import '../services/profissional_service.dart';
import '../services/servico_service.dart';

class AdminGestaoPage extends StatefulWidget {
  const AdminGestaoPage({super.key});

  @override
  State<AdminGestaoPage> createState() => _AdminGestaoPageState();
}

class _AdminGestaoPageState extends State<AdminGestaoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Servico> _servicos = [];
  List<Profissional> _profissionais = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    try {
      final servicos = await ServicoService.instance.listarAdmin();
      final profs = await ProfissionalService.instance.listarAdmin();
      if (mounted) {
        setState(() {
          _servicos = servicos;
          _profissionais = profs;
        });
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _dialogoServico() async {
    final nomeCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final durCtrl = TextEditingController(text: '60');
    final precoCtrl = TextEditingController(text: '50');

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Novo serviço'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeCtrl,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: durCtrl,
                decoration: const InputDecoration(labelText: 'Duração (min)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: precoCtrl,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (ok == true && nomeCtrl.text.isNotEmpty) {
      await ServicoService.instance.criar(
        nome: nomeCtrl.text,
        descricao: descCtrl.text.isEmpty ? null : descCtrl.text,
        duracaoMinutos: int.tryParse(durCtrl.text) ?? 60,
        preco: double.tryParse(precoCtrl.text) ?? 0,
      );
      _carregar();
    }
  }

  Future<void> _dialogoProfissional() async {
    final nomeCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final telCtrl = TextEditingController();
    final servicosAtivos = _servicos.where((s) => s.ativo).toList();
    final selecionados = <int>{};

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: const Text('Novo profissional'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeCtrl,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                ),
                TextField(
                  controller: telCtrl,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                ),
                const SizedBox(height: 8),
                const Text('Serviços:'),
                ...servicosAtivos.map(
                  (s) => CheckboxListTile(
                    title: Text(s.nome),
                    value: selecionados.contains(s.id),
                    onChanged: (v) {
                      setModal(() {
                        if (v == true) {
                          selecionados.add(s.id);
                        } else {
                          selecionados.remove(s.id);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );

    if (ok == true && nomeCtrl.text.isNotEmpty) {
      final prof = await ProfissionalService.instance.criar(
        nome: nomeCtrl.text,
        email: emailCtrl.text.isEmpty ? null : emailCtrl.text,
        telefone: telCtrl.text.isEmpty ? null : telCtrl.text,
        servicoIds: selecionados.toList(),
      );

      for (var dia = 1; dia <= 5; dia++) {
        await DisponibilidadeService.instance.criar(
          profissionalId: prof.id,
          diaSemana: dia,
          horaInicio: '08:00',
          horaFim: '18:00',
        );
      }
      _carregar();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111934),
        foregroundColor: Colors.white,
        title: const Text('Gestão'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Serviços'),
            Tab(text: 'Profissionais'),
          ],
        ),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [_listaServicos(), _listaProfissionais()],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tabController.index == 0
            ? _dialogoServico
            : _dialogoProfissional,
        backgroundColor: const Color(0xFF111934),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _listaServicos() {
    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _servicos.length,
        itemBuilder: (_, i) {
          final s = _servicos[i];
          return Card(
            child: ListTile(
              title: Text(s.nome),
              subtitle: Text(
                '${s.duracaoMinutos} min • R\$ ${s.preco.toStringAsFixed(2)}',
              ),
              trailing: s.ativo
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.cancel, color: Colors.red),
              onLongPress: () async {
                await ServicoService.instance.excluir(s.id);
                _carregar();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _listaProfissionais() {
    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _profissionais.length,
        itemBuilder: (_, i) {
          final p = _profissionais[i];
          return Card(
            child: ListTile(
              title: Text(p.nome),
              subtitle: Text(
                '${p.email ?? ""} ${p.telefone ?? ""}\nServiços: ${p.servicos.map((s) => s.nome).join(", ")}',
              ),
              isThreeLine: true,
              trailing: p.ativo
                  ? const Icon(Icons.person, color: Colors.green)
                  : const Icon(Icons.person_off, color: Colors.red),
              onLongPress: () async {
                await ProfissionalService.instance.excluir(p.id);
                _carregar();
              },
            ),
          );
        },
      ),
    );
  }
}
