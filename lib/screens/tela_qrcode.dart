import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  List<String> arvoresLidas = [];
  int indiceAtual = 0;

  @override
  void initState() {
    super.initState();
    carregarDados();
    _testarLeituraJson();
  }

  Future<void> carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    final nome = prefs.getString('nome_usuario') ?? 'Usuário';
    final chaveArvores = 'arvores_lidas_$nome';
    final chaveIndice = 'indice_atual_$nome';

    setState(() {
      arvoresLidas = prefs.getStringList(chaveArvores) ?? [];
      indiceAtual = prefs.getInt(chaveIndice) ?? 0;
    });
    print('[INFO] Índice atual carregado: $indiceAtual');
  }


  late final List<String> ordemEsperada;

  Future<void> _testarLeituraJson() async {
    try {
      print('[TESTE] Tentando ler JSON ao entrar na tela...');
      String jsonString = await rootBundle.loadString('lib/assets/bdtrilhaverde.json');
      final Map<String, dynamic> dados = jsonDecode(jsonString);
      final Map<String, dynamic> arvores = dados["Árvores Úteis"];

      setState(() {
        ordemEsperada = arvores.keys.toList(); // chaves em ordem
      });

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
      String jsonString = await rootBundle.loadString('lib/assets/bdtrilhaverde.json');
      if (!mounted) return;

      final Map<String, dynamic> dados = jsonDecode(jsonString);
      final arvores = dados["Árvores Úteis"] as Map<String, dynamic>;

      // Find the utXX key that matches the scanned QR
      String? chaveArvoreLida;
      Map<String, dynamic>? arvoreLida;

      for (var entry in arvores.entries) {
        if (entry.value["qrcode"] == codigoQr) {
          chaveArvoreLida = entry.key;
          arvoreLida = entry.value;
          break;
        }
      }

      if (chaveArvoreLida == null || arvoreLida == null) {
        _mostrarErro("QR Code \"$codigoQr\" não corresponde a nenhuma árvore!");
        return;
      }

      // Now compare the expected utXX key
      final chaveEsperada = ordemEsperada[indiceAtual];
      if (chaveArvoreLida != chaveEsperada) {
        if (!mounted) return;
        final arvoreEsperada = arvores[chaveEsperada];
        _mostrarErro(
          "Você escaneou \"${arvoreLida["arvore"]}\", mas a próxima árvore esperada é \"${arvoreEsperada["arvore"]}\".",
        );
        return;
      }

      // Tree is valid and in the correct order
      final nomeArvore = arvoreLida["arvore"];
      final perguntas = arvoreLida["perguntas"];

      if (arvoresLidas.contains(nomeArvore)) {
        _mostrarErro("Árvore \"$nomeArvore\" já foi lida!");
      } else {
        final prefs = await SharedPreferences.getInstance();
        if (!mounted) return;

        final nome = prefs.getString('nome_usuario') ?? 'Usuário';
        final chaveIndice = 'indice_atual_$nome';
        final chaveArvores = 'arvores_lidas_$nome';

        bool respondido = false;

        respondido = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TelaQuiz(
              perguntas: perguntas,
              nomeArvore: nomeArvore,
            ),
          ),
        );

        if (!mounted) return;

        if (respondido == true) {
          setState(() {
            indiceAtual++;
            arvoresLidas.add(nomeArvore);
            prefs.setInt(chaveIndice, indiceAtual);
            prefs.setStringList(chaveArvores, arvoresLidas);
          });
        }
      }
    } catch (e) {
      print('[ERRO] Falha ao processar QR code: $e');
      _mostrarErro("Erro ao processar QR code.");
    } finally {
      if (!mounted) return;
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
