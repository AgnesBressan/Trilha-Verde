import 'package:flutter/material.dart';

class TelaLogin extends StatelessWidget {
  TelaLogin({super.key});

  final TextEditingController nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Faixa superior colorida
          Container(
            height: 100,
            color: const Color(0xFF4FD8B2),
          ),

          const SizedBox(height: 40),

          // Card central com campo de nome e botão
          Center(
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF8DE3D4),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Entre com seu\nNome',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campo de texto
                  TextField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.pink[100],
                      hintText: 'Nome',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botão "Entrar"
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final nome = nomeController.text.trim();
                        if (nome.isNotEmpty) {
                          Navigator.pushNamed(context, '/principal');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[300],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
