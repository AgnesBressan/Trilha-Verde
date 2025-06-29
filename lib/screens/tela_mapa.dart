import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaMapa extends StatefulWidget {
  const TelaMapa({super.key});

  @override
  State<TelaMapa> createState() => _TelaMapaState();
}

class _TelaMapaState extends State<TelaMapa> {
  String? imagePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final nome = prefs.getString('nome_usuario') ?? 'usuário';
    final chaveArvores = 'arvores_lidas_$nome';
    final arvoresLidas = prefs.getStringList(chaveArvores) ?? [];
    final qtdArvoresLidas = arvoresLidas.length+1;

    setState(() {
      if (qtdArvoresLidas > 0 && qtdArvoresLidas < 28) {
        int num_imagem = qtdArvoresLidas+1;

        imagePath = 'lib/assets/img/planta($num_imagem).png';
      }
      else if (qtdArvoresLidas == 0) {
        imagePath = 'lib/assets/img/planta(1).png';
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Progressão'),
        backgroundColor: const Color(0xFF90E0D4),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : imagePath != null
                ? InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.asset(imagePath!),
                  )
                : const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'Comece a jogar para ver sua progressão no mapa!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
      ),
    );
  }
}