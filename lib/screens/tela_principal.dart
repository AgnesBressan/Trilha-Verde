import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  String nomeUsuario = 'usuário';

  @override
  void initState() {
    super.initState();
    carregarNomeUsuario();
  }

  Future<void> carregarNomeUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nomeUsuario = prefs.getString('nome_usuario') ?? 'usuário';
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
            // Boas-vindas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bem vindo, $nomeUsuario!',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                const CircleAvatar(
                  backgroundImage: AssetImage('lib/assets/img/icone_avatar.png'),
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

            // Mapa com largura limitada
            Container(
              width: 400, // 🔥 limite máximo de largura
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
                    'lib/assets/img/icone_mapa.png',
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

            // QR Code proporcional
            SizedBox(
              width: 100,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  'lib/assets/img/icone_qrcode.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
