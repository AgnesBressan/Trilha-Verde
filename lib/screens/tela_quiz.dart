import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaQuiz extends StatefulWidget {
  final List<dynamic> perguntas;
  final String nomeArvore;
  final String idArvore; // Adicionar o id

  const TelaQuiz({
    super.key,
    required this.perguntas,
    required this.nomeArvore,
    required this.idArvore, // Adicionar o id
  });

  @override
  State<TelaQuiz> createState() => _TelaQuizState();
}

class _TelaQuizState extends State<TelaQuiz> {
  int? respostaSelecionada;
  bool respondido = false;
  late Map<String, dynamic> perguntaAtual;
  late List<String> alternativas;
  late String respostaCorreta;

  @override
  void initState() {
    super.initState();
    perguntaAtual = widget.perguntas[0];
    alternativas = perguntaAtual['alternativas'].values.toList().cast<String>();
    respostaCorreta = perguntaAtual['resposta_correta'];
  }

  Future<void> responder(int indice) async {
    if (respondido) return;

    setState(() {
      respostaSelecionada = indice;
      respondido = true;
    });

    if (alternativas[indice] == respostaCorreta) {
      final prefs = await SharedPreferences.getInstance();
      final nomeUsuario = prefs.getString('nome_usuario') ?? 'Usuário';
      final chavePontuacao = 'pontuacao_$nomeUsuario';
      final chaveArvores = 'arvores_lidas_$nomeUsuario';

      final arvoresLidas = prefs.getStringList(chaveArvores) ?? [];

      if (!arvoresLidas.contains(widget.idArvore)) { // SALVAR O ID
        arvoresLidas.add(widget.idArvore);
        await prefs.setStringList(chaveArvores, arvoresLidas);

        final pontuacaoAtual = prefs.getInt(chavePontuacao) ?? 0;
        await prefs.setInt(chavePontuacao, pontuacaoAtual + 1);

        print('[DEBUG] Árvore ${widget.idArvore} salva como lida!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool acertou = respostaSelecionada != null && alternativas[respostaSelecionada!] == respostaCorreta;
    final double largura = MediaQuery.of(context).size.width;

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
            icon: const Icon(Icons.emoji_events),
            onPressed: () => Navigator.pushNamed(context, '/pontuacao'),
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => Navigator.pushNamed(context, '/principal'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: respondido ? Colors.grey[300] : const Color(0xFF90E0D4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  perguntaAtual['pergunta'],
                  style: TextStyle(
                    fontSize: largura * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            if (respondido && !acertou)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Resposta correta: $respostaCorreta',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: largura * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: List.generate(alternativas.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ElevatedButton(
                        onPressed: () => responder(i),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: respondido
                              ? (alternativas[i] == respostaCorreta
                                  ? Colors.green
                                  : (i == respostaSelecionada
                                      ? Colors.red
                                      : Colors.grey[300]))
                              : Colors.pink[100],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          alternativas[i],
                          style: TextStyle(fontSize: largura * 0.040),
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
                        acertou ? 'lib/assets/img/certo.png' : 'lib/assets/img/errado.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/pontuacao'),
                  icon: const Icon(Icons.emoji_events),
                  label: const Text('Pontuações'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[300],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/principal'),
                  icon: const Icon(Icons.map),
                  label: const Text('Mapa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[300],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
