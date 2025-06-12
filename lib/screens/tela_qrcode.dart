import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class TelaQRCode extends StatefulWidget {
  const TelaQRCode({super.key});

  @override
  State<TelaQRCode> createState() => _TelaQRCodeState();
}

class _TelaQRCodeState extends State<TelaQRCode> {
  String? qrText;
  bool cameraStarted = true;

  void _onDetect(BarcodeCapture capture) {
    final code = capture.barcodes.first.rawValue;
    if (code != null && qrText == null) {
      setState(() {
        qrText = code;
        cameraStarted = false;
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
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/principal');
              },
              child: Image.asset('lib/assets/img/logo.png', height: 40),
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
