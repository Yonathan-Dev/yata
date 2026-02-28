import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../core/app_exports.dart';

class RobotSectionWidget extends StatelessWidget {
  const RobotSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      duration: Constantes.standardAnimation,
      delay: const Duration(milliseconds: 300),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Tema.blanco,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Tema.negro.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset('assets/iconos/icono.png', fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
