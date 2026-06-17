import 'package:flutter/material.dart';
import 'dados_globais.dart';

class ListaClientesPage extends StatefulWidget {
  const ListaClientesPage({super.key});

  @override
  State<ListaClientesPage> createState() => _ListaClientesPageState();
}

class _ListaClientesPageState extends State<ListaClientesPage> {
  final TextEditingController _buscaController = TextEditingController();

  // MODAL SIMPLIFICADO: Sobe apenas as informações de histórico
  void _mostrarDetalhesRapidos(String nome) {
    final ultimo = DadosGlobais.getUltimoAtendimento(nome);
    final proximo = DadosGlobais.getProximoAtendimento(nome);
    final cancelados = DadosGlobais.getCancelados(nome);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
            color: Color(0xFFF3F3F3),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ocupa apenas o espaço necessário
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  nome,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111934),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // CARDS DE INFORMAÇÃO (Estilo do print anterior)
              _buildInfoCard(
                titulo: 'Último atendimento :',
                data: ultimo?['data'] ?? 'Sem registro',
                horario: ultimo?['horario'] ?? '--:--',
                corFundo: Colors.white,
                corTexto: Colors.black87,
              ),
              const SizedBox(height: 15),
              _buildInfoCard(
                titulo: 'Próximo atendimento :',
                data: proximo?['data'] ?? 'Nenhum agendado',
                horario: proximo?['horario'] ?? '--:--',
                corFundo: Colors.white,
                corTexto: Colors.black87,
              ),
              const SizedBox(height: 15),
              if (cancelados.isNotEmpty)
                _buildInfoCard(
                  titulo: 'Atendimentos cancelados:',
                  data: cancelados.first['data']!,
                  horario: cancelados.first['horario']!,
                  corFundo: const Color(0xFFB71C1C),
                  corTexto: Colors.white,
                ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required String titulo,
    required String data,
    required String horario,
    required Color corFundo,
    required Color corTexto,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(color: corTexto, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text('→ Dia: $data', style: TextStyle(color: corTexto)),
          Text('→ Horário : $horario', style: TextStyle(color: corTexto)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final agendamentos = DadosGlobais.getAgendamentosPorData('2026-05-28');

    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO
            Container(
              width: double.infinity,
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Clientes',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            // LISTA
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      TextField(
                        controller: _buscaController,
                        decoration: InputDecoration(
                          hintText: 'Pesquise seus clientes...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Expanded(
                        child: ListView.builder(
                          itemCount: agendamentos.length,
                          itemBuilder: (context, index) {
                            final cliente = agendamentos[index];
                            return _buildClienteItem(
                              cliente['nome']!,
                              cliente['telefone']!,
                            );
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

  Widget _buildClienteItem(String nome, String telefone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF111934),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Telefone: $telefone',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () => _mostrarDetalhesRapidos(nome),
                    child: const Text(
                      'Detalhes',
                      style: TextStyle(
                        color: Colors.white54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
