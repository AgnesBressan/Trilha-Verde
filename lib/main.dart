import 'package:flutter/material.dart';
import 'screens/tela_principal.dart';
import 'screens/tela_inicio.dart';
import 'screens/tela_login.dart';

void main() {
  runApp(const TrilhaVerdeApp());
}

class TrilhaVerdeApp extends StatelessWidget {
  const TrilhaVerdeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trilha Verde',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const TelaInicial(),
        '/login': (context) => TelaLogin(),
        '/principal': (context) => const TelaPrincipal(),
      },
    );
  }
}

