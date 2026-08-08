import 'package:flutter/material.dart';
import 'dados_globais.dart';

class DetalhesClientePage extends StatelessWidget {
  final String nomeCliente;

  const DetalhesClientePage({super.key, required this.nomeCliente});

  @override
  Widget build(BuildContext context) {
    // DADOS DO BANCO (SIMULADOS PELO DADOS GLOBAIS)
    final ultimo = DadosGlobais.getUltimoAtendimento(nomeCliente);

    // MOCKUP DE HISTÓRICO PARA O ESTILO DA IMAGEM
    final List<Map<String, String>> historicoMock = [
      {'servico': 'Corte de cabelo', 'data': '30 Jul 2026', 'preco': 'R\$ 45,00'},
      {'servico': 'Escova', 'data': '15 Jul 2026', 'preco': 'R\$ 30,00'},
      {'servico': 'Corte de cabelo', 'data': '02 Jul 2026', 'preco': 'R\$ 45,00'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO AZUL COM BOTÃO VOLTAR
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
                    'Detalhes',
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
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Column(
                    children: [
                      // AVATAR CENTRALIZADO
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(Icons.person, size: 50, color: Colors.grey.shade300),
                      ),
                      const SizedBox(height: 20),
                      
                      // NOME DO CLIENTE
                      Text(
                        nomeCliente,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF111934)),
                      ),
                      const SizedBox(height: 8),
                      
                      // INFORMAÇÕES DE CONTATO
                      Text(
                        '(49) 90000-1111 · maria@email.com',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                      ),
                      const SizedBox(height: 40),
                      
                      // TÍTULO HISTÓRICO
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Histórico de agendamentos',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111934)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // LISTA DE HISTÓRICO ESTILIZADA
                      ...historicoMock.map((item) => _buildHistoricoItem(
                        servico: item['servico']!,
                        data: item['data']!,
                        preco: item['preco']!,
                      )),
                      
                      // DADOS REAIS DO BANCO
                      if (ultimo != null)
                        _buildHistoricoItem(
                          servico: 'Último Atendimento',
                          data: ultimo['data']!,
                          preco: 'R\$ --,--',
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

  Widget _buildHistoricoItem({required String servico, required String data, required String preco}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                servico,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111934)),
              ),
              const SizedBox(height: 4),
              Text(
                data,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
            ],
          ),
          Text(
            preco,
            style: const TextStyle(color: Color(0xFF3498DB), fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
