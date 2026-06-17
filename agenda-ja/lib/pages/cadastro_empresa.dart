import 'package:flutter/material.dart';
import 'home_empresa.dart';

class CadastroEmpresaPage extends StatefulWidget {
  final String nomeResponsavel;

  const CadastroEmpresaPage({super.key, required this.nomeResponsavel});

  @override
  State<CadastroEmpresaPage> createState() => _CadastroEmpresaPageState();
}

class _CadastroEmpresaPageState extends State<CadastroEmpresaPage> {
  final tipoServicoController = TextEditingController();
  final enderecoController = TextEditingController();

  // Dias selecionados
  Map<String, bool> diasFuncionamento = {
    'Segunda - Feira': true,
    'Terça - Feira': false,
    'Quarta - Feira': true,
    'Quinta - Feira': false,
    'Sexta - Feira': false,
    'Sabado': false,
    'Domingo': false,
  };

  // Configurações de Turnos
  bool turnoNoiteAtivo = false;
  int duracaoAtendimentoMinutos = 60; // Padrão 1 hora

  void finalizar() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeEmpresaPage(nomeEmpresa: 'Sua Empresa'),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 80,
              alignment: Alignment.center,
              child: const Text(
                'Empresa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                ),
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
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _campoSimples(
                        'Tipo de serviço',
                        'seu tipo de serviço',
                        tipoServicoController,
                      ),
                      const SizedBox(height: 15),
                      _campoSimples(
                        'Endereço:',
                        'endereço do seu comercio',
                        enderecoController,
                      ),
                      const SizedBox(height: 25),

                      // CONTAINER DE DIAS E HORÁRIOS
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Dia de funcionamento',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Horários',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Divider(),
                            ...diasFuncionamento.keys
                                .map((dia) => _buildDiaItem(dia))
                                .toList(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // CONFIGURAÇÃO DE TURNOS E DURAÇÃO
                      const Text(
                        'Configurações de Atendimento:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: const Text('Ativar turno da noite?'),
                              value: turnoNoiteAtivo,
                              activeColor: const Color(0xFF111934),
                              onChanged: (v) =>
                                  setState(() => turnoNoiteAtivo = v),
                            ),
                            const Divider(),
                            ListTile(
                              title: const Text('Duração por atendimento:'),
                              trailing: DropdownButton<int>(
                                value: duracaoAtendimentoMinutos,
                                items: [30, 60, 90, 120].map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text('$value min'),
                                  );
                                }).toList(),
                                onChanged: (v) => setState(
                                  () => duracaoAtendimentoMinutos = v!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: finalizar,
                          child: const Text(
                            'CONTINUAR ➜',
                            style: TextStyle(
                              color: Color(0xFF111934),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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

  Widget _buildDiaItem(String dia) {
    bool selecionado = diasFuncionamento[dia]!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () =>
                    setState(() => diasFuncionamento[dia] = !selecionado),
                child: Icon(
                  selecionado ? Icons.circle : Icons.circle_outlined,
                  color: const Color(0xFF111934),
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(dia, style: const TextStyle(fontSize: 15))),
              if (selecionado) ...[
                _tagHorario('08:30'),
                const Text(' às '),
                _tagHorario('18:00'),
              ],
            ],
          ),
          if (selecionado)
            Padding(
              padding: const EdgeInsets.only(left: 35, top: 5),
              child: Row(
                children: [
                  const Text(
                    'Turnos: ',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  _tagTurno('Manhã'),
                  const SizedBox(width: 5),
                  _tagTurno('Tarde'),
                  if (turnoNoiteAtivo) ...[
                    const SizedBox(width: 5),
                    _tagTurno('Noite'),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _tagHorario(String hora) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(hora, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _tagTurno(String nome) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF111934).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        nome,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _campoSimples(
    String titulo,
    String hint,
    TextEditingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
