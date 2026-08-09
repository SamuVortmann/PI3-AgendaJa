import 'package:flutter/material.dart';

import '../models/profissional.dart';
import '../models/servico.dart';
import '../services/api_client.dart';
import '../services/disponibilidade_service.dart';
import '../services/empresa_service.dart';
import '../services/profissional_service.dart';
import '../services/servico_service.dart';

class AdminGestaoPage extends StatefulWidget {
  final int initialTab;

  const AdminGestaoPage({super.key, this.initialTab = 0});

  @override
  State<AdminGestaoPage> createState() => _AdminGestaoPageState();
}

class _AdminGestaoPageState extends State<AdminGestaoPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  List<Servico> _servicos = [];
  List<Profissional> _profissionais = [];
  Empresa? _empresa;
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _tabController.addListener(() => setState(() {}));
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final resultados = await Future.wait([
        ServicoService.instance.listarAdmin(),
        ProfissionalService.instance.listarAdmin(),
        EmpresaService.instance.minhaEmpresa(),
      ]);
      if (!mounted) return;
      setState(() {
        _servicos = resultados[0] as List<Servico>;
        _profissionais = resultados[1] as List<Profissional>;
        _empresa = resultados[2] as Empresa;
      });
    } catch (e) {
      if (mounted) setState(() => _erro = e.toString());
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _editarServico([Servico? item]) async {
    final nome = TextEditingController(text: item?.nome ?? '');
    final descricao = TextEditingController(text: item?.descricao ?? '');
    final duracao = TextEditingController(
      text: item?.duracaoMinutos.toString() ?? '',
    );
    final preco = TextEditingController(
      text: item?.preco.toStringAsFixed(2) ?? '',
    );
    final salvar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? 'Novo serviço' : 'Editar serviço'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nome,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: descricao,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: duracao,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duração em minutos',
                ),
              ),
              TextField(
                controller: preco,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Preço'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    if (salvar != true) return;
    final duracaoValor = int.tryParse(duracao.text);
    final precoValor = double.tryParse(preco.text.replaceAll(',', '.'));
    if (nome.text.trim().isEmpty ||
        duracaoValor == null ||
        precoValor == null) {
      _mensagem('Preencha nome, duração e preço corretamente.');
      return;
    }
    try {
      if (item == null) {
        await ServicoService.instance.criar(
          nome: nome.text.trim(),
          descricao: descricao.text.trim().isEmpty
              ? null
              : descricao.text.trim(),
          duracaoMinutos: duracaoValor,
          preco: precoValor,
        );
      } else {
        await ServicoService.instance.atualizar(
          item.id,
          nome: nome.text.trim(),
          descricao: descricao.text.trim(),
          duracaoMinutos: duracaoValor,
          preco: precoValor,
        );
      }
      await _carregar();
    } on ApiException catch (e) {
      _mensagem(e.message);
    }
  }

  Future<void> _editarProfissional([Profissional? item]) async {
    final nome = TextEditingController(text: item?.nome ?? '');
    final email = TextEditingController(text: item?.email ?? '');
    final telefone = TextEditingController(text: item?.telefone ?? '');
    final selecionados =
        item?.servicos.map((servico) => servico.id).toSet() ?? <int>{};
    final salvar = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            item == null ? 'Novo profissional' : 'Editar profissional',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nome,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: email,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                ),
                TextField(
                  controller: telefone,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                ),
                const SizedBox(height: 8),
                ..._servicos
                    .where((item) => item.ativo)
                    .map(
                      (servico) => CheckboxListTile(
                        title: Text(servico.nome),
                        value: selecionados.contains(servico.id),
                        onChanged: (valor) => setDialogState(() {
                          if (valor == true) {
                            selecionados.add(servico.id);
                          } else {
                            selecionados.remove(servico.id);
                          }
                        }),
                      ),
                    ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
    if (salvar != true) return;
    if (nome.text.trim().isEmpty || selecionados.isEmpty) {
      _mensagem('Informe o nome e selecione ao menos um serviço.');
      return;
    }
    try {
      if (item == null) {
        final profissional = await ProfissionalService.instance.criar(
          nome: nome.text.trim(),
          email: email.text.trim().isEmpty ? null : email.text.trim(),
          telefone: telefone.text.trim().isEmpty ? null : telefone.text.trim(),
          servicoIds: selecionados.toList(),
        );
        final empresa = _empresa;
        if (empresa != null &&
            empresa.horaAbertura != null &&
            empresa.horaFechamento != null) {
          for (final dia in empresa.diasFuncionamento) {
            await DisponibilidadeService.instance.criar(
              profissionalId: profissional.id,
              diaSemana: dia,
              horaInicio: empresa.horaAbertura!.substring(0, 5),
              horaFim: empresa.horaFechamento!.substring(0, 5),
            );
          }
        }
      } else {
        await ProfissionalService.instance.atualizar(
          item.id,
          nome: nome.text.trim(),
          email: email.text.trim(),
          telefone: telefone.text.trim(),
          servicoIds: selecionados.toList(),
        );
      }
      await _carregar();
    } on ApiException catch (e) {
      _mensagem(e.message);
    }
  }

  void _mensagem(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Serviços'),
            Tab(text: 'Profissionais'),
          ],
        ),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
          ? Center(
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
            )
          : TabBarView(
              controller: _tabController,
              children: [_listaServicos(), _listaProfissionais()],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tabController.index == 0
            ? () => _editarServico()
            : () => _editarProfissional(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _listaServicos() {
    if (_servicos.isEmpty)
      return const Center(child: Text('Nenhum serviço cadastrado.'));
    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _servicos.length,
        itemBuilder: (_, index) {
          final item = _servicos[index];
          return Card(
            child: ListTile(
              onTap: () => _editarServico(item),
              title: Text(item.nome),
              subtitle: Text(
                '${item.duracaoMinutos} min • R\$ ${item.preco.toStringAsFixed(2)}',
              ),
              trailing: Switch(
                value: item.ativo,
                onChanged: (ativo) async {
                  await ServicoService.instance.atualizar(
                    item.id,
                    ativo: ativo,
                  );
                  await _carregar();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _listaProfissionais() {
    if (_profissionais.isEmpty)
      return const Center(child: Text('Nenhum profissional cadastrado.'));
    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _profissionais.length,
        itemBuilder: (_, index) {
          final item = _profissionais[index];
          return Card(
            child: ListTile(
              onTap: () => _editarProfissional(item),
              title: Text(item.nome),
              subtitle: Text(
                item.servicos.map((servico) => servico.nome).join(', '),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Horários',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DisponibilidadesPage(profissional: item),
                      ),
                    ),
                    icon: const Icon(Icons.schedule),
                  ),
                  Switch(
                    value: item.ativo,
                    onChanged: (ativo) async {
                      await ProfissionalService.instance.atualizar(
                        item.id,
                        ativo: ativo,
                      );
                      await _carregar();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DisponibilidadesPage extends StatefulWidget {
  final Profissional profissional;

  const DisponibilidadesPage({super.key, required this.profissional});

  @override
  State<DisponibilidadesPage> createState() => _DisponibilidadesPageState();
}

class _DisponibilidadesPageState extends State<DisponibilidadesPage> {
  static const _dias = [
    'Domingo',
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
  ];
  List<DisponibilidadeSlot> _itens = [];
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
      final itens = await DisponibilidadeService.instance.listarAdmin(
        widget.profissional.id,
      );
      if (mounted) setState(() => _itens = itens);
    } catch (e) {
      if (mounted) setState(() => _erro = e.toString());
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  TimeOfDay _lerHora(String valor) {
    final partes = valor.substring(0, 5).split(':');
    return TimeOfDay(hour: int.parse(partes[0]), minute: int.parse(partes[1]));
  }

  String _hora(TimeOfDay valor) =>
      '${valor.hour.toString().padLeft(2, '0')}:${valor.minute.toString().padLeft(2, '0')}';

  Future<void> _editar([DisponibilidadeSlot? item]) async {
    var dia = item?.diaSemana ?? 1;
    var inicio = item == null
        ? const TimeOfDay(hour: 8, minute: 0)
        : _lerHora(item.horaInicio);
    var fim = item == null
        ? const TimeOfDay(hour: 18, minute: 0)
        : _lerHora(item.horaFim);
    final salvar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(item == null ? 'Novo horário' : 'Editar horário'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                initialValue: dia,
                decoration: const InputDecoration(labelText: 'Dia da semana'),
                items: List.generate(
                  _dias.length,
                  (index) =>
                      DropdownMenuItem(value: index, child: Text(_dias[index])),
                ),
                onChanged: (valor) {
                  if (valor != null) setDialogState(() => dia = valor);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Início'),
                trailing: Text(_hora(inicio)),
                onTap: () async {
                  final valor = await showTimePicker(
                    context: context,
                    initialTime: inicio,
                  );
                  if (valor != null) setDialogState(() => inicio = valor);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Fim'),
                trailing: Text(_hora(fim)),
                onTap: () async {
                  final valor = await showTimePicker(
                    context: context,
                    initialTime: fim,
                  );
                  if (valor != null) setDialogState(() => fim = valor);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
    if (salvar != true || !mounted) return;
    final inicioMinutos = inicio.hour * 60 + inicio.minute;
    final fimMinutos = fim.hour * 60 + fim.minute;
    if (fimMinutos <= inicioMinutos) {
      _mensagem('O horário final deve ser posterior ao inicial.');
      return;
    }
    try {
      if (item == null) {
        await DisponibilidadeService.instance.criar(
          profissionalId: widget.profissional.id,
          diaSemana: dia,
          horaInicio: _hora(inicio),
          horaFim: _hora(fim),
        );
      } else {
        await DisponibilidadeService.instance.atualizar(
          item.id,
          diaSemana: dia,
          horaInicio: _hora(inicio),
          horaFim: _hora(fim),
        );
      }
      await _carregar();
    } on ApiException catch (e) {
      _mensagem(e.message);
    }
  }

  Future<void> _excluir(DisponibilidadeSlot item) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover horário?'),
        content: Text(
          '${_dias[item.diaSemana]}, ${item.horaInicio.substring(0, 5)}–${item.horaFim.substring(0, 5)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await DisponibilidadeService.instance.excluir(item.id);
      await _carregar();
    } on ApiException catch (e) {
      _mensagem(e.message);
    }
  }

  void _mensagem(String texto) {
    if (mounted)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Horários • ${widget.profissional.nome}')),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
          ? Center(
              child: ElevatedButton(onPressed: _carregar, child: Text(_erro!)),
            )
          : _itens.isEmpty
          ? const Center(child: Text('Nenhuma disponibilidade cadastrada.'))
          : RefreshIndicator(
              onRefresh: _carregar,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _itens.length,
                itemBuilder: (_, index) {
                  final item = _itens[index];
                  return Card(
                    child: ListTile(
                      onTap: () => _editar(item),
                      leading: const Icon(Icons.schedule),
                      title: Text(_dias[item.diaSemana]),
                      subtitle: Text(
                        '${item.horaInicio.substring(0, 5)} – ${item.horaFim.substring(0, 5)}',
                      ),
                      trailing: IconButton(
                        tooltip: 'Remover',
                        onPressed: () => _excluir(item),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editar(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
