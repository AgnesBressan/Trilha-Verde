import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'tela_quiz.dart';

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
      final codigoArvore = uri != null && uri.pathSegments.isNotEmpty
          ? uri.pathSegments.last.replaceAll('.php', '')
          : code;

      await _processQRCode(codigoArvore);
    }
  }

  Future<void> _processQRCode(String codigoQr) async {
    try {
      print('[DEBUG] Código QR processado: "$codigoQr"');
      print('[DEBUG] Lendo arquivo JSON...');
      String jsonString = await rootBundle.loadString('lib/assets/bdtrilhaverde.json');
      final Map<String, dynamic> dados = jsonDecode(jsonString);
      print('[DEBUG] JSON carregado com sucesso.');

      final arvores = dados["Árvores Úteis"] as Map<String, dynamic>;

      if (arvores.containsKey(codigoQr)) {
        final arvoreEncontrada = arvores[codigoQr];
        final perguntas = arvoreEncontrada["perguntas"];
        final nomeArvore = arvoreEncontrada["arvore"];

        print('[DEBUG] Árvore encontrada: $nomeArvore');
        print('[DEBUG] Perguntas: $perguntas');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TelaQuiz(
              perguntas: perguntas,
              nomeArvore: nomeArvore,
            ),
          ),
        );
      } else {
        print('[ERRO] Nenhuma árvore corresponde ao QR code: "$codigoQr"');
        _mostrarErro("QR Code \"$codigoQr\" não reconhecido!");
      }
    } catch (e) {
      print('[ERRO] Falha ao carregar ou processar o JSON: $e');
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
        automaticallyImplyLeading: false,
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
