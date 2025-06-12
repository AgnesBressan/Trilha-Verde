import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaQuiz extends StatefulWidget {
  const TelaQuiz({super.key});

  @override
  State<TelaQuiz> createState() => _TelaQuizState();
}

class _TelaQuizState extends State<TelaQuiz> {
  int? respostaSelecionada;
  final int respostaCorreta = 2;
  bool respondido = false;

  final List<String> alternativas = [
    'Letra (a)',
    'Letra (b)',
    'Letra (c)',
    'Letra (d)',
  ];

  Future<void> responder(int indice) async {
    if (respondido) return;

    setState(() {
      respostaSelecionada = indice;
      respondido = true;
    });

    if (indice == respostaCorreta) {
      final prefs = await SharedPreferences.getInstance();
      final nomeUsuario = prefs.getString('nome_usuario') ?? 'Usuário';
      final chavePontuacao = 'pontuacao_$nomeUsuario';
      final pontuacaoAtual = prefs.getInt(chavePontuacao) ?? 0;
      await prefs.setInt(chavePontuacao, pontuacaoAtual + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool acertou = respostaSelecionada == respostaCorreta;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF90E0D4),
        elevation: 0,
        toolbarHeight: 80,
        title: Image.asset('lib/assets/img/logo.png', height: 40),
        centerTitle: false,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Navigator.pushNamed(context, '/menu'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Pergunta
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: respondido ? Colors.grey[300] : const Color(0xFF90E0D4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Pergunta 1',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            if (respondido && !acertou)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Resposta correta: ${alternativas[respostaCorreta]}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // Alternativas com ícone sobreposto
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: List.generate(alternativas.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => responder(i),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: respondido
                                ? (i == respostaCorreta
                                    ? Colors.green
                                    : (i == respostaSelecionada
                                        ? Colors.red
                                        : Colors.grey[300]))
                                : Colors.pink[100],
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            minimumSize: const Size(200, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            alternativas[i],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                if (respondido)
                  Positioned(
                    top: 40,
                    child: SizedBox(
                      height: 140,
                      width: 140,
                      child: Image.asset(
                        acertou
                            ? 'lib/assets/img/certo.png'
                            : 'lib/assets/img/errado.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            ),

            const Spacer(),

            if (respondido)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/pontuacao');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[300],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Pontuações'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/principal');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[300],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Voltar ao Mapa'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
