import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaPontuacao extends StatefulWidget {
  const TelaPontuacao({super.key});

  @override
  State<TelaPontuacao> createState() => _TelaPontuacaoState();
}

class _TelaPontuacaoState extends State<TelaPontuacao> {
  String nomeUsuario = 'Usuário';
  int arvoresLidas = 14; // Este valor virá do backend futuramente
  final int totalArvores = 20;

  @override
  void initState() {
    super.initState();
    carregarNome();
  }

  Future<void> carregarNome() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nomeUsuario = prefs.getString('nome_usuario') ?? 'Usuário';
    });
  }

  @override
  Widget build(BuildContext context) {
    double percentual = arvoresLidas / totalArvores;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF90E0D4),
        elevation: 0,
        toolbarHeight: 100,
        title: Image.asset('lib/assets/img/logo.png', height: 50),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/menu');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[200],
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Pontuação', style: TextStyle(color: Colors.black, fontSize: 16)),
            ),

            const SizedBox(height: 24),

            CircularPercentIndicator(
              radius: 100,
              lineWidth: 20,
              percent: percentual.clamp(0.0, 1.0),
              progressColor: Colors.teal,
              backgroundColor: Colors.redAccent,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$arvoresLidas/$totalArvores',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Árvores\nobservadas',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2, // mais "compacto" verticalmente
              children: [
                if (arvoresLidas >= 1) _buildTrofeu('Árvore X'),
                if (arvoresLidas >= 3) _buildTrofeu('Árvore Y'),
                if (arvoresLidas >= 5) _buildTrofeu('Pontuação Y'),
                if (arvoresLidas >= 7) _buildTrofeu('X Respostas Corretas'),
                if (arvoresLidas >= 10) _buildTrofeu('Pontuação X'),
                if (arvoresLidas >= 14) _buildTrofeu('Árvore Z'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrofeu(String titulo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.emoji_events, size: 48),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
