import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'tela_quiz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaQRCode extends StatefulWidget {
  const TelaQRCode({super.key});

  @override
  State<TelaQRCode> createState() => _TelaQRCodeState();
}

class _TelaQRCodeState extends State<TelaQRCode> {
  String? qrText;
  bool cameraStarted = true;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _testarLeituraJson();
  }

  Future<void> _testarLeituraJson() async {
    try {
      print('[TESTE] Tentando ler JSON ao entrar na tela...');
      String jsonString = await rootBundle.loadString('lib/assets/bdtrilhaverde.json');
      final Map<String, dynamic> dados = jsonDecode(jsonString);

      print('[SUCESSO] JSON carregado. Árvores disponíveis:');
      for (var chave in dados["Árvores Úteis"].keys) {
        final nome = dados["Árvores Úteis"][chave]["arvore"];
        print('- $chave → $nome');
      }
    } catch (e) {
      print('[ERRO] Erro ao carregar JSON no initState: $e');
    }
  }

  void _onDetect(BarcodeCapture capture) async {
    final code = capture.barcodes.first.rawValue;
    if (code != null && !isProcessing) {
      setState(() {
        isProcessing = true;
        qrText = code;
        cameraStarted = false;
      });

      final uri = Uri.tryParse(code);
      final idArvore = uri != null && uri.queryParameters.containsKey('narvore')
          ? uri.queryParameters['narvore']
          : null;

      if (idArvore != null) {
        await _processQRCode(idArvore);
      } else {
        _mostrarErro("QR Code inválido!");
      }
    }
  }

Future<void> _processQRCode(String idArvore) async {
  try {
    print('[DEBUG] Código QR processado: "$idArvore"');
    String jsonString = await rootBundle.loadString('lib/assets/bdtrilhaverde.json');
    final Map<String, dynamic> dados = jsonDecode(jsonString);
    final arvores = dados["Árvores Úteis"] as Map<String, dynamic>;

    if (!arvores.containsKey(idArvore)) {
      _mostrarErro("QR Code \"$idArvore\" não reconhecido!");
      return;
    }

    final arvoreEncontrada = arvores[idArvore];
    final int sequenciaLida = arvoreEncontrada["sequencia"];
    final nomeArvore = arvoreEncontrada["arvore"];
    final perguntas = arvoreEncontrada["perguntas"];

    final prefs = await SharedPreferences.getInstance();

    final int ultimaSequencia = prefs.getInt('ultimaSequenciaDesbloqueada') ?? 0;
    final String? ultimaArvoreLida = prefs.getString('ultimaArvoreLida');

    // 1. Se a árvore já foi lida, mas ainda não respondida corretamente (usuário errou)
    if (idArvore == ultimaArvoreLida && sequenciaLida == ultimaSequencia + 1) {
      // permite refazer a pergunta da árvore atual
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaQuiz(
            perguntas: perguntas,
            nomeArvore: nomeArvore,
            idArvore: idArvore,
          ),
        ),
      );
      return;
    }

    // 2. Se a árvore já foi visitada (sequência menor que última desbloqueada)
    if (sequenciaLida <= ultimaSequencia) {
      _mostrarErro("Você já visitou essa árvore!");
      return;
    }

    // 3. Se for a árvore atual (sequencia == ultima + 1), deixa entrar e registra o ID
    if (sequenciaLida == ultimaSequencia + 1) {
      // marca como última árvore lida (permite repetir enquanto não acertar)
      await prefs.setString('ultimaArvoreLida', idArvore);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaQuiz(
            perguntas: perguntas,
            nomeArvore: nomeArvore,
            idArvore: idArvore,
          ),
        ),
      );
      return;
    }

    // 4. Qualquer outro caso: árvore futura ainda não desbloqueada
    _mostrarErro("Você ainda não desbloqueou esta árvore.\nSiga a ordem da trilha!");
  } catch (e) {
    _mostrarErro("Erro ao carregar dados: $e");
  } finally {
    setState(() {
      isProcessing = false;
    });
  }
}

  void _mostrarErro(String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Erro"),
        content: Text(mensagem),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                cameraStarted = true;
                qrText = null;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF90E0D4),
        elevation: 0,
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/principal');
              },
              child: Image.asset('lib/assets/img/logo.png', height: 50),
            ),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          if (cameraStarted)
            MobileScanner(
              controller: MobileScannerController(
                facing: CameraFacing.back,
              ),
              onDetect: _onDetect,
            )
          else
            const Center(
              child: Text(
                'QR Code detectado!',
                style: TextStyle(fontSize: 18),
              ),
            ),
          Column(
            children: [
              const SizedBox(height: 16),
              const Spacer(),
              if (qrText != null)
                Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: Text(
                    'QR Lido: $qrText',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
