import 'package:flutter/material.dart';

import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/empresa_service.dart';
import 'admin_gestao_page.dart';

class PerfilEmpresaPage extends StatefulWidget {
  const PerfilEmpresaPage({super.key});

  @override
  State<PerfilEmpresaPage> createState() => _PerfilEmpresaPageState();
}

class _PerfilEmpresaPageState extends State<PerfilEmpresaPage> {
  final nomeController = TextEditingController();
  final cnpjController = TextEditingController();
  final enderecoController = TextEditingController();
  final telefoneController = TextEditingController();
  Empresa? _empresa;
  bool _carregando = true;
  bool _salvando = false;
  bool _editando = false;
  String? _erro;
  Set<int> _diasSelecionados = {};
  TimeOfDay? _horaAbertura;
  TimeOfDay? _horaFechamento;

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
      final empresa = await EmpresaService.instance.minhaEmpresa();
      nomeController.text = empresa.nome;
      cnpjController.text = empresa.cnpj ?? '';
      enderecoController.text = empresa.endereco ?? '';
      telefoneController.text = empresa.telefone ?? '';
      if (mounted) {
        setState(() {
          _empresa = empresa;
          _diasSelecionados = empresa.diasFuncionamento.toSet();
          _horaAbertura = _lerHorario(empresa.horaAbertura);
          _horaFechamento = _lerHorario(empresa.horaFechamento);
        });
      }
    } catch (e) {
      if (mounted) setState(() => _erro = e.toString());
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _salvar() async {
    if (nomeController.text.trim().isEmpty ||
        enderecoController.text.trim().isEmpty ||
        telefoneController.text.trim().isEmpty) {
      _mensagem('Nome, endereço e telefone são obrigatórios.');
      return;
    }
    if (_diasSelecionados.isEmpty ||
        _horaAbertura == null ||
        _horaFechamento == null) {
      _mensagem('Selecione os dias e os horários de funcionamento.');
      return;
    }
    final abertura = _horaAbertura!.hour * 60 + _horaAbertura!.minute;
    final fechamento = _horaFechamento!.hour * 60 + _horaFechamento!.minute;
    if (fechamento <= abertura) {
      _mensagem('O fechamento deve ser posterior à abertura.');
      return;
    }
    setState(() => _salvando = true);
    try {
      final empresa = await EmpresaService.instance.atualizarMinhaEmpresa(
        nome: nomeController.text.trim(),
        cnpj: cnpjController.text.trim().isEmpty
            ? null
            : cnpjController.text.trim(),
        endereco: enderecoController.text.trim(),
        telefone: telefoneController.text.trim(),
        diasFuncionamento: _diasSelecionados.toList()..sort(),
        horaAbertura: _formatarHorario(_horaAbertura!),
        horaFechamento: _formatarHorario(_horaFechamento!),
      );
      await AuthService.instance.me();
      if (mounted)
        setState(() {
          _empresa = empresa;
          _editando = false;
          _diasSelecionados = empresa.diasFuncionamento.toSet();
          _horaAbertura = _lerHorario(empresa.horaAbertura);
          _horaFechamento = _lerHorario(empresa.horaFechamento);
        });
    } on ApiException catch (e) {
      _mensagem(e.message);
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _sair() async {
    await AuthService.instance.logout();
    if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  TimeOfDay? _lerHorario(String? valor) {
    if (valor == null || valor.length < 5) return null;
    final partes = valor.substring(0, 5).split(':');
    return TimeOfDay(hour: int.parse(partes[0]), minute: int.parse(partes[1]));
  }

  String _formatarHorario(TimeOfDay valor) =>
      '${valor.hour.toString().padLeft(2, '0')}:${valor.minute.toString().padLeft(2, '0')}';

  Future<void> _selecionarHorario({required bool abertura}) async {
    final atual = abertura ? _horaAbertura : _horaFechamento;
    final selecionado = await showTimePicker(
      context: context,
      initialTime:
          atual ??
          (abertura
              ? const TimeOfDay(hour: 8, minute: 0)
              : const TimeOfDay(hour: 18, minute: 0)),
    );
    if (selecionado == null || !mounted) return;
    setState(() {
      if (abertura) {
        _horaAbertura = selecionado;
      } else {
        _horaFechamento = selecionado;
      }
    });
  }

  void _iniciarEdicao() {
    final empresa = _empresa!;
    setState(() {
      _diasSelecionados = empresa.diasFuncionamento.toSet();
      _horaAbertura = _lerHorario(empresa.horaAbertura);
      _horaFechamento = _lerHorario(empresa.horaFechamento);
      _editando = true;
    });
  }

  @override
  void dispose() {
    nomeController.dispose();
    cnpjController.dispose();
    enderecoController.dispose();
    telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Dados da empresa' : 'Gestão da empresa'),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
          ? Center(
              child: ElevatedButton(onPressed: _carregar, child: Text(_erro!)),
            )
          : _editando
          ? _formulario()
          : _menu(),
    );
  }

  Widget _menu() {
    final empresa = _empresa!;
    final dias = empresa.diasFuncionamento.map(_nomeDia).join(', ');
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const CircleAvatar(radius: 48, child: Icon(Icons.business, size: 44)),
        const SizedBox(height: 14),
        Text(
          empresa.nome,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(empresa.endereco ?? '', textAlign: TextAlign.center),
        const SizedBox(height: 28),
        ListTile(
          leading: const Icon(Icons.edit_outlined),
          title: const Text('Dados da empresa'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _iniciarEdicao,
        ),
        ListTile(
          leading: const Icon(Icons.content_cut),
          title: const Text('Serviços oferecidos'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminGestaoPage(initialTab: 0),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.people_outline),
          title: const Text('Profissionais'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminGestaoPage(initialTab: 1),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.schedule),
          title: Text(dias.isEmpty ? 'Funcionamento não informado' : dias),
          subtitle: Text(
            '${_horaCurta(empresa.horaAbertura)} - ${_horaCurta(empresa.horaFechamento)}',
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            'Sair da conta',
            style: TextStyle(color: Colors.red),
          ),
          onTap: _sair,
        ),
      ],
    );
  }

  Widget _formulario() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        TextField(
          controller: nomeController,
          decoration: const InputDecoration(
            labelText: 'Nome do estabelecimento',
          ),
        ),
        const SizedBox(height: 20),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Dias de funcionamento',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: List.generate(7, (dia) {
            return FilterChip(
              label: Text(_nomeDia(dia)),
              selected: _diasSelecionados.contains(dia),
              onSelected: (selecionado) => setState(() {
                if (selecionado) {
                  _diasSelecionados.add(dia);
                } else {
                  _diasSelecionados.remove(dia);
                }
              }),
            );
          }),
        ),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.schedule),
          title: const Text('Abertura'),
          trailing: Text(
            _horaAbertura == null ? '--:--' : _formatarHorario(_horaAbertura!),
          ),
          onTap: () => _selecionarHorario(abertura: true),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.schedule_outlined),
          title: const Text('Fechamento'),
          trailing: Text(
            _horaFechamento == null
                ? '--:--'
                : _formatarHorario(_horaFechamento!),
          ),
          onTap: () => _selecionarHorario(abertura: false),
        ),
        TextField(
          controller: cnpjController,
          decoration: const InputDecoration(labelText: 'CNPJ'),
        ),
        TextField(
          controller: enderecoController,
          decoration: const InputDecoration(labelText: 'Endereço'),
        ),
        TextField(
          controller: telefoneController,
          decoration: const InputDecoration(labelText: 'Telefone'),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _salvando ? null : _salvar,
          child: _salvando
              ? const CircularProgressIndicator()
              : const Text('Salvar alterações'),
        ),
        TextButton(
          onPressed: () {
            final empresa = _empresa!;
            nomeController.text = empresa.nome;
            cnpjController.text = empresa.cnpj ?? '';
            enderecoController.text = empresa.endereco ?? '';
            telefoneController.text = empresa.telefone ?? '';
            setState(() => _editando = false);
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }

  String _nomeDia(int dia) {
    const nomes = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    return dia >= 0 && dia < nomes.length ? nomes[dia] : '$dia';
  }

  String _horaCurta(String? valor) =>
      valor == null || valor.length < 5 ? '--:--' : valor.substring(0, 5);
}
