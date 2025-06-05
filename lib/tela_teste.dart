import 'package:flutter/material.dart';

class TelaTeste extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste de Imagens'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Logo:', style: TextStyle(fontWeight: FontWeight.bold)),
            Image.asset('assets/logo.png'),
            SizedBox(height: 16),

            Text('Avatar:', style: TextStyle(fontWeight: FontWeight.bold)),
            Image.asset('assets/icone_avatar.png'),
            SizedBox(height: 16),

            Text('Mapa:', style: TextStyle(fontWeight: FontWeight.bold)),
            Image.asset('assets/icone_mapa.png'),
            SizedBox(height: 16),

            Text('QR Code:', style: TextStyle(fontWeight: FontWeight.bold)),
            Image.asset('assets/icone_qrcode.png'),
          ],
        ),
      ),
    );
  }
}
