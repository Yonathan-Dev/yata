import 'package:flutter/material.dart';

import '../../core/app_exports.dart';

class IconoYataWidget extends StatelessWidget {
  const IconoYataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/iconos/yata_reco.png',
      fit: BoxFit.contain,
      alignment: Alignment.topCenter,
      height: Constantes.imagenHeight,
    );
  }
}
