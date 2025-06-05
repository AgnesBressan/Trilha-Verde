import 'package:flutter/material.dart';

class TelaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double larguraTela = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF90E0D4),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/logo.png', height: 40),
            const Icon(Icons.menu, color: Colors.black),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 👈 mantém tamanho mínimo
            mainAxisAlignment: MainAxisAlignment.center, // 👈 centraliza verticalmente
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Linha de boas-vindas com avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Bem vindo, usuário!',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/icone_avatar.png'),
                    radius: 20,
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

              // Mapa com borda e sombra
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.asset(
                      'assets/icone_mapa.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Leia um QR Code de uma árvore\npara iniciar o jogo!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 24),

              // QR Code
              SizedBox(
                width: larguraTela * 0.25,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    'assets/icone_qrcode.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
