import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homecliente.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  String tipoConta = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      body: SingleChildScrollView(

        child: Column(
          children: [

            // NAVBAR AZUL

            Container(
  width: double.infinity,
  height: 140,

  decoration: const BoxDecoration(
    color: Color(0xFF06153D),

    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(60),
    ),
  ),

  child: const Center(
    child: Text(
      'Cadastro',

      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w400,
      ),
    ),
  ),
),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 30,
              ),

              child: Column(
                children: [

                  campo(
                    titulo: 'Nome completo:',
                    hint: 'seu nome completo',
                    controller: nomeController,
                  ),

                  const SizedBox(height: 22),

                  campo(
                    titulo: 'Email:',
                    hint: 'seuemail@gmail.com',
                    controller: emailController,
                  ),

                  const SizedBox(height: 22),

                  campoTelefone(),

                  const SizedBox(height: 22),

                  campo(
                    titulo: 'Senha:',
                    hint: '**************',
                    controller: senhaController,
                    obscure: true,
                  ),

                  const SizedBox(height: 22),

                  campo(
                    titulo: 'Confirmar senha:',
                    hint: '**************',
                    controller: confirmarSenhaController,
                    obscure: true,
                  ),

                  const SizedBox(height: 22),

                  // TIPO CONTA

                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        const Text(
                          'Tipo de conta:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [

                            Radio(
                              value: 'cliente',
                              groupValue: tipoConta,

                              activeColor: const Color(0xFF06153D),

                              onChanged: (value) {
                                setState(() {
                                  tipoConta = value!;
                                });
                              },
                            ),

                            const Text(
                              'Cliente',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),

                        Row(
                          children: [

                            Radio(
                              value: 'empresa',
                              groupValue: tipoConta,

                              activeColor: const Color(0xFF06153D),

                              onChanged: (value) {
                                setState(() {
                                  tipoConta = value!;
                                });
                              },
                            ),

                            const Text(
                              'Empresa/ profissional',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 45),

                  Align(
                    alignment: Alignment.centerRight,

                    child: GestureDetector(

                      onTap: () {

                        if (tipoConta == 'cliente') {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) => HomeClientePage(
                                nome: nomeController.text,
                              ),
                            ),
                          );
                        }
                      },

                      child: const Text(
                        'CONTINUAR ➜',

                        style: TextStyle(
                          color: Color(0xFF06153D),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // CAMPO NORMAL

  Widget campo({
    required String titulo,
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
  }) {

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
            titulo,

            style: const TextStyle(
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 5),

          TextField(
            controller: controller,
            obscureText: obscure,

            decoration: InputDecoration(
              hintText: hint,

              hintStyle: const TextStyle(
                color: Colors.grey,
              ),

              border: InputBorder.none,
              isCollapsed: true,
            ),
          ),
        ],
      ),
    );
  }

  // CAMPO TELEFONE

  Widget campoTelefone() {

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(
            'Telefone:',

            style: TextStyle(
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 5),

          TextField(
            controller: telefoneController,
            keyboardType: TextInputType.phone,

            inputFormatters: [
              TelefoneInputFormatter(),
            ],

            decoration: const InputDecoration(
              hintText: '(49)99999-9999',
              border: InputBorder.none,
              isCollapsed: true,
            ),
          ),
        ],
      ),
    );
  }
}

// FORMATADOR TELEFONE

class TelefoneInputFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {

    String numeros = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.length > 11) {
      numeros = numeros.substring(0, 11);
    }

    String textoFormatado = '';

    if (numeros.isNotEmpty) {
      textoFormatado += '(${numeros.substring(0, numeros.length >= 2 ? 2 : numeros.length)})';
    }

    if (numeros.length > 2) {

      textoFormatado += numeros.substring(
        2,
        numeros.length >= 7 ? 7 : numeros.length,
      );
    }

    if (numeros.length > 7) {

      textoFormatado += '-${numeros.substring(7)}';
    }

    return TextEditingValue(
      text: textoFormatado,

      selection: TextSelection.collapsed(
        offset: textoFormatado.length,
      ),
    );
  }
}