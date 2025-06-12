import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

class QRCodeMobile extends StatefulWidget {
  const QRCodeMobile({super.key}); // ✅ Adicionado `const`

  @override
  State<QRCodeMobile> createState() => _QRCodeMobileState();
}

class _QRCodeMobileState extends State<QRCodeMobile> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF90E0D4),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('lib/assets/img/logo.png', height: 40),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          const Text(
            'QR Code\nÁrvore X',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF90E0D4),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                width: 250,
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.red,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 8,
                      cutOutSize: 200,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (qrText != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'QR Lido: $qrText',
                style: const TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      setState(() {
        qrText = scanData.code;
      });
      Navigator.pushNamed(context, '/quiz');
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
