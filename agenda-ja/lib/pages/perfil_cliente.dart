import 'package:flutter/material.dart';
import 'notificacoes.dart'; // Importa a tela de notificações

class PerfilPage extends StatefulWidget {
  final String nome;
  final String telefone;

  const PerfilPage({
    super.key,
    required this.nome,
    required this.telefone,
  });

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;
  bool _isEditing = false;

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

  void _exibirDialogoSenha() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Senha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Senha atual'), obscureText: true),
            TextField(decoration: const InputDecoration(labelText: 'Nova senha'), obscureText: true),
            TextField(decoration: const InputDecoration(labelText: 'Confirmar nova senha'), obscureText: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Senha alterada com sucesso!')));
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    // CABEÇALHO
                    Container(
                      width: double.infinity,
                      height: 220,
                      color: const Color(0xFF111934),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10, left: 10,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/logo.png', width: 60, errorBuilder: (context, error, stackTrace) => const Icon(Icons.circle, color: Colors.white, size: 30)),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      const CircleAvatar(radius: 45, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white, size: 50)),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (!_isEditing) ...[
                                              Text(_nomeController.text, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                                              const SizedBox(height: 5),
                                              Text('Telefone: ${_telefoneController.text}', style: const TextStyle(color: Colors.white70, fontSize: 16)),
                                            ] else ...[
                                              TextField(controller: _nomeController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Nome', hintStyle: TextStyle(color: Colors.white54))),
                                              TextField(controller: _telefoneController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Telefone', hintStyle: TextStyle(color: Colors.white54))),
                                            ]
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // CONTEÚDO
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: constraints.maxHeight - 220),
                      decoration: const BoxDecoration(color: Color(0xFFF1F1F1), borderRadius: BorderRadius.only(topLeft: Radius.circular(60))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                        child: Column(
                          children: [
                            _buildProfileButton(
                              titulo: _isEditing ? 'Salvar Perfil' : 'Editar Perfil',
                              onTap: () {
                                setState(() {
                                  if (_isEditing) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil atualizado!')));
                                  }
                                  _isEditing = !_isEditing;
                                });
                              },
                              color: _isEditing ? Colors.blue.shade100 : Colors.white,
                            ),
                            const SizedBox(height: 20),
                            _buildProfileButton(
                              titulo: 'Alterar senha',
                              onTap: _exibirDialogoSenha,
                            ),
                            const SizedBox(height: 20),
                            _buildProfileButton(
                              titulo: 'Notificações',
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificacoesPage()));
                              },
                            ),
                            const SizedBox(height: 50),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                                icon: const Icon(Icons.arrow_back, color: Colors.black54, size: 18),
                                label: const Text('SAIR', style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileButton({required String titulo, required VoidCallback onTap, Color color = Colors.white}) {
    return SizedBox(
      width: double.infinity, height: 65,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.black87, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        child: Text(titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
      ),
    );
  }
}
