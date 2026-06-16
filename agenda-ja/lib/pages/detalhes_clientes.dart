import 'package:flutter/material.dart';
import 'dados_globais.dart';

class DetalhesClientePage extends StatelessWidget {
  final String nomeCliente;

  const DetalhesClientePage({super.key, required this.nomeCliente});

  @override
  Widget build(BuildContext context) {
    // BUSCANDO DADOS REAIS DO DADOS GLOBAIS
    final ultimo = DadosGlobais.getUltimoAtendimento(nomeCliente);
    final proximo = DadosGlobais.getProximoAtendimento(nomeCliente);
    final cancelados = DadosGlobais.getCancelados(nomeCliente);

    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              color: const Color(0xFF111934),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'A\nAgenda Já',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Detalhes clientes',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111934),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          nomeCliente,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 35),

                      // DADOS REAIS: ÚLTIMO ATENDIMENTO
                      _buildInfoCard(
                        titulo: 'Último atendimento :',
                        data: ultimo?['data'] ?? 'Sem registro',
                        horario: ultimo?['horario'] ?? '--:--',
                        corFundo: Colors.white,
                        corTexto: Colors.black87,
                      ),
                      const SizedBox(height: 20),

                      // DADOS REAIS: PRÓXIMO ATENDIMENTO
                      _buildInfoCard(
                        titulo: 'Próximo atendimento :',
                        data: proximo?['data'] ?? 'Nenhum agendado',
                        horario: proximo?['horario'] ?? '--:--',
                        corFundo: Colors.white,
                        corTexto: Colors.black87,
                      ),
                      const SizedBox(height: 60),

                      // DADOS REAIS: CANCELADOS
                      if (cancelados.isNotEmpty)
                        _buildInfoCard(
                          titulo: 'Atendimentos cancelados:',
                          data: cancelados.first['data']!,
                          horario: cancelados.first['horario']!,
                          corFundo: const Color(0xFFB71C1C),
                          corTexto: Colors.white,
                        )
                      else
                        const Text(
                          'Nenhum atendimento cancelado',
                          style: TextStyle(color: Colors.grey),
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

  Widget _buildInfoCard({
    required String titulo,
    required String data,
    required String horario,
    required Color corFundo,
    required Color corTexto,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: TextStyle(color: corTexto, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            '→ Dia: $data',
            style: TextStyle(color: corTexto.withOpacity(0.9)),
          ),
          Text(
            '→ Horário : $horario',
            style: TextStyle(color: corTexto.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }
}
