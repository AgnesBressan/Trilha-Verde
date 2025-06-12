import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'tela_qrcode_web.dart' if (dart.library.io) 'tela_qrcode_mobile.dart';

class TelaQRCode extends StatelessWidget {
  const TelaQRCode({super.key});

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? const QRCodeWeb() : const QRCodeMobile();
  }
}
