import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}
class _TelaInicialState extends State<TelaInicial> {
  String? ultimoUsuario;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsuario();
  }

  Future<void> _loadUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    ultimoUsuario = prefs.getString('ultimo_usuario');
    if (ultimoUsuario != null) {
      Navigator.pushReplacementNamed(context, '/principal');
    }
    else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3E5DC),
      body: Center(
        child: isLoading
        ? const CircularProgressIndicator()
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagem central
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset('lib/assets/img/parque 1.png'),
            ),
            const SizedBox(height: 16),

            // Texto "Trilha Verde"
            const Text(
              'Trilha Verde',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 32),

            // Botão que leva à próxima tela
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[200],
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Trilha das Árvores Úteis',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
