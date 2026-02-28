import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constantes.dart';
import '../../core/tema.dart';

class LoadingWidget extends StatefulWidget {
  final String mensaje;

  const LoadingWidget({super.key, required this.mensaje});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: isDark
          ? Tema.negro.withValues(alpha: 0.5)
          : Tema.negro.withValues(alpha: 0.3),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicador de progreso mejorado
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Círculo de fondo sutil
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Tema.rojo.withValues(alpha: 0.15),
                        ),
                      ),
                      // Indicador principal
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Tema.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: Constantes.padding * 2),

                  // Mensaje con mejor tipografía
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Text(
                      widget.mensaje,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.15,
                        height: 1.5,
                        color: Tema.blanco,
                        shadows: [
                          Shadow(
                            color: Tema.negro.withValues(alpha: 0.3),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: Constantes.padding * 0.5),

                  // Indicador de puntos animados
                  _BuildDots(isDark: isDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildDots extends StatefulWidget {
  final bool isDark;

  const _BuildDots({required this.isDark});

  @override
  State<_BuildDots> createState() => _BuildDotsState();
}

class _BuildDotsState extends State<_BuildDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _dotController,
            builder: (context, child) {
              final delay = index * 0.2;
              final value = (_dotController.value - delay).clamp(0.0, 1.0);
              final opacity =
                  (Curves.easeInOut.transform((value * 2).clamp(0.0, 1.0)) *
                      0.6) +
                  0.2;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Tema.blanco.withValues(alpha: opacity),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
