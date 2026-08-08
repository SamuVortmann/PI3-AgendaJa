import 'package:flutter/material.dart';

class PerfilEmpresaPage extends StatefulWidget {
  const PerfilEmpresaPage({super.key});

  @override
  State<PerfilEmpresaPage> createState() => _PerfilEmpresaPageState();
}

class _PerfilEmpresaPageState extends State<PerfilEmpresaPage> {
  // Estado para controlar qual seção está visível: 'menu', 'dados', 'servicos', 'profissionais', 'horarios'
  String _secaoAtual = 'menu';

  // Controllers para Dados da Empresa
  final nomeController = TextEditingController(text: 'Salão Bella');
  final cnpjController = TextEditingController(text: '00.000.000/0000-00');
  final enderecoController = TextEditingController(text: 'Concórdia, SC');
  final telefoneController = TextEditingController(text: '(49) 90000-0000');

  void _voltar() {
    if (_secaoAtual == 'menu') {
      Navigator.pop(context);
    } else {
      setState(() => _secaoAtual = 'menu');
    }
  }

  @override
  Widget build(BuildContext context) {
    String titulo = 'Meu perfil';
    if (_secaoAtual == 'dados') titulo = 'Dados da empresa';
    if (_secaoAtual == 'servicos') titulo = 'Serviços oferecidos';
    if (_secaoAtual == 'profissionais') titulo = 'Profissionais';
    if (_secaoAtual == 'horarios') titulo = 'Horários';

    return Scaffold(
      backgroundColor: const Color(0xFF1F2937),
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO DINÂMICO
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                    onPressed: _voltar,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    titulo,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            // CORPO BRANCO COM CANTO ARREDONDADO (60px)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildConteudo(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConteudo() {
    switch (_secaoAtual) {
      case 'dados':
        return _buildEdicaoDados();
      case 'servicos':
        return _buildEdicaoServicos();
      case 'profissionais':
        return _buildEdicaoProfissionais();
      case 'horarios':
        return _buildEdicaoHorarios();
      default:
        return _buildMenuPrincipal();
    }
  }

  // --- MENU PRINCIPAL (Fiel ao wireframe) ---
  Widget _buildMenuPrincipal() {
    return SingleChildScrollView(
      key: const ValueKey('menu'),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFF3F4F6),
            child: Icon(Icons.person, size: 50, color: Color(0xFFD1D5DB)),
          ),
          const SizedBox(height: 16),
          const Text('Salão Bella', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
          const Text('Concórdia, SC', style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF))),
          const SizedBox(height: 40),
          _buildMenuItem(Icons.edit_note, 'Dados da empresa', () => setState(() => _secaoAtual = 'dados')),
          _buildMenuItem(Icons.content_cut, 'Serviços oferecidos', () => setState(() => _secaoAtual = 'servicos')),
          _buildMenuItem(Icons.people_outline, 'Profissionais', () => setState(() => _secaoAtual = 'profissionais')),
          _buildMenuItem(Icons.access_time, 'Horários de funcionamento', () => setState(() => _secaoAtual = 'horarios')),
          const SizedBox(height: 24),
          _buildMenuItem(Icons.logout, 'Sair da conta', () => Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false), isLogout: true),
        ],
      ),
    );
  }

  // --- SEÇÃO: DADOS DA EMPRESA ---
  Widget _buildEdicaoDados() {
    return SingleChildScrollView(
      key: const ValueKey('dados'),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildTextField('Nome do estabelecimento', nomeController),
          _buildTextField('CNPJ', cnpjController),
          _buildTextField('Endereço', enderecoController),
          _buildTextField('Telefone', telefoneController),
          const SizedBox(height: 32),
          _buildBotaoSalvar(),
        ],
      ),
    );
  }

  // --- SEÇÃO: SERVIÇOS ---
  Widget _buildEdicaoServicos() {
    return SingleChildScrollView(
      key: const ValueKey('servicos'),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildItemGestao('Corte de Cabelo', 'R 45,00'),
          _buildItemGestao('Barba', 'R 25,00'),
          _buildItemGestao('Manicure', 'R 35,00'),
          _buildAddButton('Adicionar serviço'),
          const SizedBox(height: 32),
          _buildBotaoSalvar(),
        ],
      ),
    );
  }

  // --- SEÇÃO: PROFISSIONAIS ---
  Widget _buildEdicaoProfissionais() {
    return SingleChildScrollView(
      key: const ValueKey('profissionais'),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildItemGestao('Ana Souza', 'Especialista em Corte'),
          _buildItemGestao('Bia Lima', 'Manicure'),
          _buildAddButton('Adicionar profissional'),
          const SizedBox(height: 32),
          _buildBotaoSalvar(),
        ],
      ),
    );
  }

  // --- SEÇÃO: HORÁRIOS ---
  Widget _buildEdicaoHorarios() {
    return SingleChildScrollView(
      key: const ValueKey('horarios'),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildHorarioItem('Segunda a Sexta', '08:00 - 19:00'),
          _buildHorarioItem('Sábado', '08:00 - 12:00'),
          _buildHorarioItem('Domingo', 'Fechado'),
          const SizedBox(height: 32),
          _buildBotaoSalvar(),
        ],
      ),
    );
  }

  // --- COMPONENTES REUTILIZÁVEIS ---

  Widget _buildMenuItem(IconData icone, String titulo, VoidCallback onTap, {bool isLogout = false}) {
    final color = isLogout ? const Color(0xFFEF4444) : const Color(0xFF1F2937);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Icon(icone, color: color, size: 24),
      title: Text(titulo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color)),
      trailing: isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFD1D5DB)),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true, fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemGestao(String titulo, String subtitulo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
            Text(subtitulo, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          ]),
          const Icon(Icons.edit_outlined, size: 20, color: Color(0xFF2563EB)),
        ],
      ),
    );
  }

  Widget _buildHorarioItem(String dia, String horario) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(dia, style: const TextStyle(color: Color(0xFF1F2937))),
          Text(horario, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
        ],
      ),
    );
  }

  Widget _buildAddButton(String texto) {
    return TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add, size: 20, color: Color(0xFF2563EB)),
      label: Text(texto, style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBotaoSalvar() {
    return SizedBox(
      width: double.infinity, height: 52,
      child: ElevatedButton(
        onPressed: () => setState(() => _secaoAtual = 'menu'),
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: const Text('Salvar Alterações', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
