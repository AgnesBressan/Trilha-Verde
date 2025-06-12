import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Start of ExpandableImage component ---
// You can move this to a separate file (e.g., expandable_image.dart)
// and import it if you prefer.

class ExpandableImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double aspectRatio;
  final BoxFit initialFit;
  final BorderRadius borderRadius;
  final List<BoxShadow>? boxShadow;
  final bool isAsset; // Added to distinguish between asset and file images

  const ExpandableImage({
    super.key,
    required this.imagePath,
    this.width = 400,
    this.aspectRatio = 4 / 3,
    this.initialFit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.boxShadow = const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6,
        offset: Offset(0, 4),
      ),
    ],
    this.isAsset = true, // Default to asset image
  });

  ImageProvider _getImageProvider() {
    if (isAsset) {
      return AssetImage(imagePath);
    } else {
      return FileImage(File(imagePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Unique tag for the Hero animation.
    final String heroTag = 'expandable_image_${imagePath.hashCode}'; // Use hashCode for uniqueness

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            barrierDismissible: true,
            pageBuilder: (BuildContext context, _, __) {
              return _ExpandedImageView(
                imagePath: imagePath,
                heroTag: heroTag,
                isAsset: isAsset,
              );
            },
          ),
        );
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: boxShadow,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Hero(
            tag: heroTag,
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Image(
                image: _getImageProvider(),
                fit: initialFit,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpandedImageView extends StatelessWidget {
  final String imagePath;
  final String heroTag;
  final bool isAsset;

  const _ExpandedImageView({
    required this.imagePath,
    required this.heroTag,
    required this.isAsset,
  });

  ImageProvider _getImageProvider() {
    if (isAsset) {
      return AssetImage(imagePath);
    } else {
      return FileImage(File(imagePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Hero(
                tag: heroTag,
                child: Center(
                  child: Image(
                    image: _getImageProvider(),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16.0,
              right: 16.0,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30.0),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  tooltip: 'Close',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// --- End of ExpandableImage component ---

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  String nomeUsuario = 'usuário';
  File? imagemPerfil;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    final nome = prefs.getString('nome_usuario') ?? 'usuário';
    final caminhoImagem = prefs.getString('imagem_perfil_$nome');

    setState(() {
      nomeUsuario = nome;
      if (caminhoImagem != null && File(caminhoImagem).existsSync()) {
        imagemPerfil = File(caminhoImagem);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double larguraTela = MediaQuery.of(context).size.width;

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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Boas-vindas com imagem personalizada
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bem vindo, $nomeUsuario!',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: imagemPerfil != null
                      ? FileImage(imagemPerfil!)
                      : const AssetImage('lib/assets/img/icone_avatar.png')
                          as ImageProvider,
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Trilha Verde',
              style: TextStyle(
                fontSize: 24,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // Mapa com largura limitada - REPLACED WITH ExpandableImage
            const ExpandableImage(
              imagePath: 'lib/assets/img/icone_mapa.png',
              width: 400, // You can adjust or use the default
              aspectRatio: 4 / 3,
              initialFit: BoxFit.cover,
              borderRadius: BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
              isAsset: true, // Explicitly state it's an asset
            ),

            const SizedBox(height: 24),

            const Text(
              'Leia um QR Code de uma árvore\npara iniciar o jogo!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),

            // QR Code clicável
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/qrcode');
              },
              child: SizedBox(
                width: larguraTela * 0.25,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    'lib/assets/img/icone_qrcode.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
