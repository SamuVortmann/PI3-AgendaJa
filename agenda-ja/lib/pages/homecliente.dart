import 'package:flutter/material.dart';

import '../models/agendamento.dart';
import '../services/agendamento_service.dart';
import '../services/api_client.dart';
import '../services/auth_session.dart';
import '../utils/date_utils.dart';
import 'agendar.dart';
import 'menu.dart';

class HomeClientePage extends StatefulWidget {
  const HomeClientePage({super.key});

  @override
  State<HomeClientePage> createState() => _HomeClientePageState();
}

class _HomeClientePageState extends State<HomeClientePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Agendamento> _agendamentos = [];
  bool _carregando = true;
  int _selectedIndex = 0;

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
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _agendamentos = []);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar agendamentos: ${e.message}'), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _agendamentos = []);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar agendamentos: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Agendamento? get proximoAgendamento {
    if (_agendamentos.isEmpty) return null;
    final agora = DateTime.now();
    final futuros = _agendamentos.where((a) => a.dataHoraInicio.isAfter(agora) && !a.isCancelado).toList();
    if (futuros.isEmpty) return null;
    futuros.sort((a, b) => a.dataHoraInicio.compareTo(b.dataHoraInicio));
    return futuros.first;
  }

  @override
  Widget build(BuildContext context) {
    final usuario = AuthSession.instance.usuario!;
    final nome = usuario.nome;
    final telefone = usuario.telefone ?? '';

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: MenuCliente(nome: nome, telefone: telefone),
      body: SafeArea(
        child: Column(
          children: [
            // PARTE SUPERIOR ORIGINAL MANTIDA
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: const BoxDecoration(
                color: Color(0xFF111934),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    icon: const Icon(Icons.menu, color: Colors.white, size: 34),
                  ),
                  Image.asset('assets/logo.png', width: 100,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image, color: Colors.white)),
                  const SizedBox(width: 34),
                ],
              ),
            ),
            
            // CONTEÚDO NOVO CONFORME WIREFRAME
            Expanded(
              child: RefreshIndicator(
                onRefresh: _carregar,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Olá, $nome!',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF111934)),
                          ),
                          const Icon(Icons.notifications_none_outlined, size: 28),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // BARRA DE BUSCA
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.search, color: Colors.grey),
                            hintText: 'Buscar serviço ou profissional',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      const Text(
                        'Próximo agendamento',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF111934)),
                      ),
                      const SizedBox(height: 15),
                      
                      // CARD PRÓXIMO AGENDAMENTO
                      _buildProximoAgendamentoCard(),
                      
                      const SizedBox(height: 30),
                      
                      const Text(
                        'Serviços em destaque',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF111934)),
                      ),
                      const SizedBox(height: 15),
                      
                      // LISTA DE SERVIÇOS (MOCKUP ESTILO WIREFRAME)
                      _buildServicoItem('Corte de Cabelo', '45 min', 'R\$ 45,00'),
                      _buildServicoItem('Manicure', '40 min', 'R\$ 35,00'),
                      _buildServicoItem('Barba', '25 min', 'R\$ 25,00'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF111934),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none_outlined), activeIcon: Icon(Icons.notifications), label: 'Avisos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildProximoAgendamentoCard() {
    final ag = proximoAgendamento;
    
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (ag == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: const Text('Nenhum agendamento futuro encontrado.', style: TextStyle(color: Colors.grey)),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
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
                    ag.servicoNome ?? 'Serviço',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'com Profissional', // Idealmente viria do banco
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              Container(
                width: 60,
                height: 25,
                decoration: BoxDecoration(
                  color: const Color(0xFF2ECC71),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                '${formatarData(ag.dataHoraInicio)} · ${formatarHora(ag.dataHoraInicio)}',
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServicoItem(String nome, String tempo, String preco) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.cut, color: Colors.black87),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(tempo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(preco, style: const TextStyle(color: Color(0xFF3498DB), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
