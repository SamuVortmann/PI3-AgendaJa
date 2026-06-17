import 'package:flutter/material.dart';
import 'menu.dart';
import 'agendar.dart';
import 'detalhes_agendamento.dart';
import 'dados_globais.dart';

class HomeClientePage extends StatefulWidget {
  final String nome;
  final String telefone;

  const HomeClientePage({
    super.key,
    required this.nome,
    required this.telefone,
  });

  @override
  State<HomeClientePage> createState() => _HomeClientePageState();
}

class _HomeClientePageState extends State<HomeClientePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int mesExibido = 4; // Maio (Índice 4)
  int anoExibido = 2026;
  int? diaSelecionado; 
  String filtroSelecionado = 'Todos';

  final List<String> meses = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];

  // Função para obter o dia da semana em que o mês começa (0 = Segunda, 6 = Domingo)
  // Para simplificar o protótipo, vamos usar uma lógica baseada em Maio/2026 começando na Sexta (índice 4 no Grid)
  int getOffsetMes(int mes, int ano) {
    // Maio/2026 começa na Sexta (índice 4 se considerarmos D=0, S=1, T=2, Q=3, Q=4, S=5, S=6)
    // No GridView com 7 colunas:
    // Maio: Começa na Sexta (index 5 no grid se D=0)
    if (mes == 4) return 5; // Maio
    if (mes == 5) return 1; // Junho (Maio tem 31 dias, 31+5 = 36. 36%7 = 1)
    if (mes == 6) return 3; // Julho
    return 0;
  }

  int getDiasNoMes(int mes, int ano) {
    if (mes == 1) return (ano % 4 == 0) ? 29 : 28; // Fevereiro
    if ([3, 5, 8, 10].contains(mes)) return 30; // Abril, Junho, Setembro, Novembro
    return 31;
  }

  void mudarMes(int direcao) {
    setState(() {
      diaSelecionado = null; // Limpa seleção ao mudar de mês
      mesExibido += direcao;
      if (mesExibido > 11) {
        mesExibido = 0;
        anoExibido++;
      } else if (mesExibido < 0) {
        mesExibido = 11;
        anoExibido--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF111934),
      drawer: MenuCliente(nome: widget.nome, telefone: widget.telefone),
      body: GestureDetector(
        onTap: () => setState(() => diaSelecionado = null),
        child: SafeArea(
          child: Column(
            children: [
              // NAVBAR
              Container(
                width: double.infinity,
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                color: const Color(0xFF111934),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                      icon: const Icon(Icons.menu, color: Colors.white, size: 34),
                    ),
                    Image.asset(
                      'assets/logo.png',
                      width: 100,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.white),
                    ),
                    const SizedBox(width: 34),
                  ],
                ),
              ),

              // CONTEÚDO
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(45)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Olá, ${widget.nome}!', style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 15),

                        // PESQUISA
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBEBEB),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: TextField(onTap: () => setState(() => diaSelecionado = null), decoration: const InputDecoration(hintText: 'Buscar serviço, empresa...', border: InputBorder.none, hintStyle: TextStyle(fontSize: 16)))),
                              const Icon(Icons.search, color: Colors.grey, size: 28),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),
                        SizedBox(
                          width: 130, height: 35,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (ctx) => AgendarPage(nomeEmpresa: widget.nome)
                                )
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF111934), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            child: const Text('+ Agendar', style: TextStyle(color: Colors.white, fontSize: 14)),
                          ),
                        ),

                        const SizedBox(height: 25),
                        Row(
                          children: [
                            const Text('Sua agenda', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            // NAVEGAÇÃO DE MÊS
                            Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.chevron_left, color: Color(0xFF111934)),
                                  onPressed: () => mudarMes(-1),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(color: const Color(0xFF111934), borderRadius: BorderRadius.circular(5)),
                                  child: Text('${meses[mesExibido].toLowerCase()} $anoExibido', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.chevron_right, color: Color(0xFF111934)),
                                  onPressed: () => mudarMes(1),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // CALENDÁRIO
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white, 
                              border: Border.all(color: Colors.grey.shade400), 
                              borderRadius: BorderRadius.circular(14)
                            ),
                            child: Column(
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [Text('D'), Text('S'), Text('T'), Text('Q'), Text('Q'), Text('S'), Text('S')]),
                                const SizedBox(height: 10),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 42, // Aumentado para cobrir todos os meses
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                                  itemBuilder: (context, index) {
                                    int offset = getOffsetMes(mesExibido, anoExibido);
                                    int dia = index - offset + 1;
                                    int diasNoMes = getDiasNoMes(mesExibido, anoExibido);

                                    if (dia < 1 || dia > diasNoMes) return const SizedBox();
                                    
                                    bool isSelecionado = diaSelecionado == dia;
                                    
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          diaSelecionado = (diaSelecionado == dia) ? null : dia;
                                        });
                                      },
                                      child: Center(
                                        child: Container(
                                          width: 35, height: 35,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: isSelecionado ? const Color(0xFF111934) : Colors.transparent,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text('$dia', style: TextStyle(color: isSelecionado ? Colors.white : Colors.black, fontSize: 16)),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                
                                if (diaSelecionado != null) 
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: _buildCompromissosBox(),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25), 

                        const Text('Próximo agendamento', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('→ 02/06/2026', style: TextStyle(fontSize: 16)),
                              const Text('local: hospital unimed', style: TextStyle(fontSize: 16)),
                              const Text('horário: 14:40', style: TextStyle(fontSize: 16)),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const DetalhesAgendamentoPage())),
                                  child: const Text('Detalhes', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, decoration: TextDecoration.underline)),
                                ),
                              ),
                            ],
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
      ),
    );
  }

  Widget _buildCompromissosBox() {
    final List<Map<String, dynamic>> compromissosDoDia = DadosGlobais.meusAgendamentosCliente.where((agendamento) {
      final String dataAgendamento = agendamento['data']!;
      final List<String> partesData = dataAgendamento.split('/');
      if (partesData.length == 3) {
        final String diaAgendamento = partesData[0];
        final String mesAgendamento = partesData[1];
        final String anoAgendamento = partesData[2];
        return diaAgendamento == diaSelecionado!.toString().padLeft(2, '0') &&
               mesAgendamento == (mesExibido + 1).toString().padLeft(2, '0') && 
               anoAgendamento == anoExibido.toString();
      }
      return false;
    }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF111934),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Compromissos:', style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 10),
          if (compromissosDoDia.isEmpty)
            const Text(
              'Sem compromissos para este dia.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            )
          else
            ...compromissosDoDia.map((compromisso) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildCompromissoItem(
                  context,
                  compromisso['horario']!,
                  compromisso['local']!,
                  '',
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildCompromissoItem(BuildContext context, String hora, String local, String cidade) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text('$hora - $local $cidade', style: const TextStyle(color: Colors.white, fontSize: 15), overflow: TextOverflow.ellipsis),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const DetalhesAgendamentoPage())),
          child: const Text('Detalhes', style: TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic, decoration: TextDecoration.underline)),
        ),
      ],
    );
  }
}
