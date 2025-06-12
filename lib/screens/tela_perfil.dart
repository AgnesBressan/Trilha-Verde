import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  File? imagemPerfil;
  String nomeUsuario = 'Usuário';

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    final nome = prefs.getString('nome_usuario') ?? 'Usuário';
    final chaveImagem = 'imagem_perfil_$nome';

    setState(() {
      nomeUsuario = nome;
      final imagemPath = prefs.getString(chaveImagem);
      if (imagemPath != null && File(imagemPath).existsSync()) {
        imagemPerfil = File(imagemPath);
      }
    });
  }

  Future<void> selecionarImagem() async {
    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      final prefs = await SharedPreferences.getInstance();
      final chaveImagem = 'imagem_perfil_$nomeUsuario';

      await prefs.setString(chaveImagem, imagem.path);

      setState(() {
        imagemPerfil = File(imagem.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF90E0D4),
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/principal');
          },
          child: Image.asset('lib/assets/img/logo.png', height: 40),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Imagem de perfil
              CircleAvatar(
                radius: 60,
                backgroundImage: imagemPerfil != null
                    ? FileImage(imagemPerfil!)
                    : const AssetImage('lib/assets/img/icone_avatar.png') as ImageProvider,
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: selecionarImagem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[200],
                ),
                child: const Text(
                  'Alterar Foto',
                  style: TextStyle(color: Colors.black),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                nomeUsuario,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF90E0D4),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Sair do Perfil',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
