import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/auth_session.dart';
import 'meus-agendamentos.dart';
import 'notificacoes.dart';

class PerfilPage extends StatefulWidget {
  final String nome;
  final String telefone;

  const PerfilPage({super.key, required this.nome, required this.telefone});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.nome);
    _telefoneController = TextEditingController(text: widget.telefone);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> _sair() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCELAR')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('SAIR', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmar == true) {
      await AuthService.instance.logout();
      if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO COM BOTÃO VOLTAR
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              color: const Color(0xFF111934),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context), 
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24)
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Meu perfil',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(45)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    children: [
                      // AVATAR
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        child: Icon(Icons.person, size: 50, color: Colors.grey.shade400),
                      ),
                      const SizedBox(height: 30),
                      
                      // CAMPOS DE TEXTO (SOMENTE LEITURA OU EDIÇÃO VISUAL)
                      TextField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _telefoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefone',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // OPÇÕES ADICIONAIS
                      _buildMenuOption(
                        icon: Icons.calendar_today_outlined,
                        titulo: 'Meus agendamentos',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MeusAgendamentosPage())),
                      ),
                      _buildMenuOption(
                        icon: Icons.notifications_none_outlined,
                        titulo: 'Notificações',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificacoesPage())),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // BOTÃO SAIR
                      GestureDetector(
                        onTap: _sair,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, color: Colors.red.shade700, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'SAIR DA CONTA',
                                style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
                              ),
                            ],
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

  Widget _buildMenuOption({required IconData icon, required String titulo, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Icon(icon, color: Colors.black87, size: 28),
      title: Text(
        titulo,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF111934)),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    );
  }
}
