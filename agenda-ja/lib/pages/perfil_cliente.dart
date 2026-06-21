import 'package:flutter/material.dart';

import '../services/auth_service.dart';
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
    await AuthService.instance.logout();
    if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
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
              height: 220,
              color: const Color(0xFF111934),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo.png', width: 60, errorBuilder: (_, __, ___) => const Icon(Icons.circle, color: Colors.white)),
                        const SizedBox(height: 20),
                        Text(_nomeController.text, style: const TextStyle(color: Colors.white, fontSize: 20)),
                        Text('Telefone: ${_telefoneController.text}', style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      _buildProfileButton(
                        titulo: 'Notificações',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificacoesPage())),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton.icon(
                          onPressed: _sair,
                          icon: const Icon(Icons.arrow_back, color: Colors.black54, size: 18),
                          label: const Text('SAIR', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
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

  Widget _buildProfileButton({required String titulo, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(titulo, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
