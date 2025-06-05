import 'package:flutter/material.dart';

class TelaMenu extends StatelessWidget {
  const TelaMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF90E0D4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF90E0D4),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/principal');
          },
          child: Image.asset('lib/assets/img/logo.png', height: 40),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'MENU',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),

              MenuItem(icon: Icons.emoji_events, label: 'Pontuação', rota: '/pontuacao'),
              MenuItem(icon: Icons.person, label: 'Perfil', rota: '/perfil'),
              MenuItem(icon: Icons.map, label: 'Mapa', rota: '/mapa'),
              MenuItem(icon: Icons.logout, label: 'Sair', rota: '/login'),
              MenuItem(icon: Icons.phone, label: 'Contato', rota: '/contato'),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String rota;

  const MenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.rota,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, rota);
        },
        child: Row(
          children: [
            // Ícone à esquerda
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE5E5E5),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: Colors.black),
            ),

            const SizedBox(width: 8),

            // Retângulo com texto
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
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
