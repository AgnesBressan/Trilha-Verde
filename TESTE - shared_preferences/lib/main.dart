// main.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(home: NomeUsuarioScreen()));
}

class NomeUsuarioScreen extends StatefulWidget {
  @override
  _NomeUsuarioScreenState createState() => _NomeUsuarioScreenState();
}

class _NomeUsuarioScreenState extends State<NomeUsuarioScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _salvarNomeENavegar() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarios = prefs.getStringList('usuarios') ?? [];
    final nome = _controller.text;

    if (!usuarios.contains(nome)) {
      usuarios.add(nome);
      await prefs.setStringList('usuarios', usuarios);
      await prefs.setInt('${nome}_pontuacao', 0);
      await prefs.setStringList('${nome}_arvoresVisitadas', []);
    }

    await prefs.setString('nome', nome);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => QuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bem-vindo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Digite seu nome:'),
            TextField(controller: _controller),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarNomeENavegar,
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Map<String, dynamic>? arvoreAtual;
  String? nomeArvoreSelecionada;
  String? alternativaSelecionada;
  int pontuacao = 0;
  List<String> arvoresVisitadas = [];
  String nomeUsuario = '';

  @override
  void initState() {
    super.initState();
    carregarProgresso();
  }

  Future<void> carregarProgresso() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nomeUsuario = prefs.getString('nome') ?? 'Desconhecido';
      pontuacao = prefs.getInt('${nomeUsuario}_pontuacao') ?? 0;
      arvoresVisitadas = prefs.getStringList('${nomeUsuario}_arvoresVisitadas') ?? [];
    });
  }

  Future<void> salvarProgresso(String nomeArvore, bool acertou) async {
    final prefs = await SharedPreferences.getInstance();
    if (acertou && !arvoresVisitadas.contains(nomeArvore)) {
      setState(() {
        pontuacao++;
        arvoresVisitadas.add(nomeArvore);
      });
      await prefs.setInt('${nomeUsuario}_pontuacao', pontuacao);
      await prefs.setStringList('${nomeUsuario}_arvoresVisitadas', arvoresVisitadas);
    }
  }

  Future<void> carregarArvore(String nome) async {
    final jsonStr = await rootBundle.loadString('assets/bdtrilhaverde.json');
    final data = json.decode(jsonStr);
    for (var trilha in data.values) {
      if (trilha[nome] != null) {
        setState(() {
          nomeArvoreSelecionada = nome;
          arvoreAtual = trilha[nome];
          alternativaSelecionada = null;
        });
        return;
      }
    }
    setState(() {
      arvoreAtual = null;
    });
  }

  void _sair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('nome');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => NomeUsuarioScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz das Árvores'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _sair,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Usuário: $nomeUsuario'),
            Text('Pontuação: $pontuacao'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => carregarArvore('Ipê-Amarelo'),
              child: Text('Simular QR Code: Ipê-Amarelo'),
            ),
            ElevatedButton(
              onPressed: () => carregarArvore('Guapuruvu'),
              child: Text('Simular QR Code: Guapuruvu'),
            ),
            SizedBox(height: 20),
            if (arvoreAtual != null) ...[
              Text(
                arvoreAtual!["perguntas"][0]["pergunta"],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...(arvoreAtual!["perguntas"][0]["alternativas"] as Map<String, dynamic>).entries.map(
                (entry) => RadioListTile<String>(
                  title: Text('${entry.key}) ${entry.value}'),
                  value: entry.value,
                  groupValue: alternativaSelecionada,
                  onChanged: (val) {
                    setState(() => alternativaSelecionada = val);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final correta = arvoreAtual!["perguntas"][0]["resposta_correta"];
                  final acertou = alternativaSelecionada == correta;
                  salvarProgresso(nomeArvoreSelecionada!, acertou);
                  final resultado = acertou ? 'Resposta correta!' : 'Resposta errada!';
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(resultado),
                      content: Text('Resposta correta: $correta'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('Confirmar Resposta'),
              )
            ]
          ],
        ),
      ),
    );
  }
}
