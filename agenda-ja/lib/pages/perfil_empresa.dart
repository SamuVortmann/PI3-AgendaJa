import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  final String nome;
  final String telefone;
  final String localizacao;

  const PerfilPage({
    super.key,
    required this.nome,
    required this.telefone,
    this.localizacao = "Joinville - SC",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111934),
      body: Column(
        children: [
          // TOPO AZUL
          Container(
            width: double.infinity,
            height: 230,
            color: const Color(0xFF111934),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo.png",
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.business,
                        color: Colors.white,
                        size: 40,
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.white30,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nome,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),

                              Text(
                                "Telefone: $telefone",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),

                              Text(
                                "Localização: $localizacao",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // PARTE CINZA
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFEDEDED),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(45)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Column(
                  children: [
                    _botaoPerfil("Editar Perfil"),
                    const SizedBox(height: 20),

                    _botaoPerfil("Alterar senha"),
                    const SizedBox(height: 20),

                    _botaoPerfil("Notificações"),

                    const Spacer(),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 18,
                        ),
                        label: const Text(
                          "SAIR",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
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
    );
  }

  static Widget _botaoPerfil(String texto) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
    );
  }
}
