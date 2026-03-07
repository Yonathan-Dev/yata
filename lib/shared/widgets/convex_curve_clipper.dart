import 'package:flutter/material.dart';

class ConvexCurveClipper extends CustomClipper<Path> {
  final double screenHeight;
  final double screenWidth;

  ConvexCurveClipper({required this.screenHeight, required this.screenWidth});

  @override
  Path getClip(Size size) {
    final path = Path();

    // Calcular aspect ratio para ajustes
    final aspectRatio = screenWidth / screenHeight;
    final isTablet = screenWidth > 600;

    // Altura lateral: valores adaptativos con límites
    double sideHeight;
    if (isTablet) {
      // Tablets: curva menos pronunciada
      sideHeight = (size.height * 0.28).clamp(120.0, 280.0);
    } else if (aspectRatio > 0.55) {
      // Pantallas más anchas (landscape o pantallas cortas)
      sideHeight = (size.height * 0.25).clamp(100.0, 200.0);
    } else {
      // Teléfonos normales
      sideHeight = (size.height * 0.22).clamp(80.0, 180.0);
    }

    // Altura del punto más alto de la curva
    double curveTopHeight;
    if (isTablet) {
      curveTopHeight = size.height * 0.05;
    } else {
      curveTopHeight = -size.height * 0.02;
    }

    path.moveTo(0, size.height);
    path.lineTo(0, sideHeight);
    path.cubicTo(
      size.width * 0.15,
      curveTopHeight,
      size.width * 0.85,
      curveTopHeight,
      size.width,
      sideHeight,
    );

    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
