import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(dispositivoProvider.notifier).obtenerVersionApp(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios en el estado de autenticación
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated && !next.isLoading) {
        _solicitarPermisos();
      }
      if (next.error != null) {
        SnackbarUtil.snackbarError(context, message: next.error!);
      }
    });

    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Tema.blanco,
        body: Stack(
          children: [_buildContent(context), _buildLoadingIndicator(context)],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            const SizedBox(height: Constantes.separacion * 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [const IconoYataWidget()],
            ),
          ],
        ),
        Expanded(
          child: Stack(
            children: [
              ClipPath(
                clipper: _TopConvexCurveClipper(),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Tema.primaryColor, Color(0xFF21002B)],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [const FormularioWidget()],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return LoadingWidget(mensaje: authState.mensaje);
    }
    return const SizedBox.shrink();
  }

  Future<void> _solicitarPermisos() async {
    try {
      var cameraStatus = await Permission.camera.status;
      if (cameraStatus.isPermanentlyDenied) {
        if (mounted) {
          _mostrarDialogoPermisosDenegados();
        }
        return;
      }
      if (cameraStatus.isDenied) {
        cameraStatus = await Permission.camera.request();
      }
      var storageStatus = await Permission.storage.status;
      if (storageStatus.isPermanentlyDenied) {
        if (mounted) {
          _mostrarDialogoPermisosDenegados();
        }
        return;
      }
      if (storageStatus.isDenied) {
        storageStatus = await Permission.storage.request();
      }
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtil.snackbarError(
          context,
          message: 'Error al solicitar permisos:',
        );
        context.go('/home');
      }
    }
  }

  void _mostrarDialogoPermisosDenegados() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permisos necesarios'),
        content: const Text(
          'Esta aplicación requiere permisos de cámara para funcionar correctamente. '
          'Por favor, active el permiso en la configuración de su dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Abrir configuración'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/home');
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }
}

class _TopConvexCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 80);
    path.quadraticBezierTo(size.width / 2, -80, size.width, 80);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
