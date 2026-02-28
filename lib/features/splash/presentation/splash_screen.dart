import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constantes.dart';
import '../../../core/tema.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../shared/providers/shared_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _animationSize;

  @override
  void initState() {
    super.initState();

    // Inicializar el controlador de animación
    _animationController = AnimationController(
      vsync: this,
      duration: Constantes.extraLongAnimation,
    );

    // Animación de escala (de 0.5 a 1.0)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Animación de opacidad (de 0 a 1)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationSize = Tween<double>(
      begin: 0.0,
      end: 300.0,
    ).animate(_animationController);

    // Iniciar la animación
    _animationController.forward();

    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Esperar a que termine la animación (4 segundos)
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    // Verificar el estado de autenticación
    final authState = ref.read(authProvider);

    // Esperar un momento adicional si aún está cargando
    if (authState.isLoading) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
    }

    // Marcar que ya vio el splash en SharedPreferences
    final prefsService = ref.read(preferencesServiceProvider);
    await prefsService.setHasSeenSplash(true);

    // Navegar según el estado de autenticación
    final isAuthenticated = ref.read(authProvider).isAuthenticated;

    if (!mounted) return;
    if (isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/auth');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF21002B), Tema.primaryColor],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    'assets/iconos/a_blanco.png',
                    width: _animationSize.value,
                    height: _animationSize.value,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
