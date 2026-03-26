import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool photoTaken = false;
  XFile? photoFile;
  final PermissionsService _permissionsService = PermissionsService();

  @override
  void initState() {
    super.initState();
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
    final screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SafeArea(bottom: false, child: _buildLogoSection(context)),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: ConvexCurveClipper(
                  screenHeight: screenSize.height,
                  screenWidth: screenSize.width,
                ),
                child: Container(
                  width: double.infinity,
                  color: Tema.primaryColor,
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 50),
                  _buildHeaderSection(context),
                  const SizedBox(height: 20),
                  Expanded(child: _buildFormSection(context)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return FadeInDown(
      duration: Constantes.standardAnimation,
      child: Column(
        children: [
          if (ref.watch(currentStepProvider) != 1) ...[
            Text(
              'Crear cuenta',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Tema.blanco,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Completa tus datos',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Tema.blanco,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildStepper(context),
          ],
        ],
      ),
    );
  }

  Widget _buildStepper(BuildContext context) {
    final steps = [
      '1. Datos\npersonales',
      '2. Datos de\nidentificación',
      '3.Datos de\ningreso',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Línea conectora
            return Expanded(
              child: Container(
                height: 3,
                color: Tema.blanco.withValues(alpha: 0.5),
              ),
            );
          }
          final stepIndex = index ~/ 2;
          final isActive = stepIndex <= ref.watch(currentStepProvider);

          return Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? Tema.blanco : Colors.transparent,
                  border: Border.all(color: Tema.blanco, width: 2),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                steps[stepIndex],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Tema.blanco,
                  fontSize: 11,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFormSection(BuildContext context) {
    switch (ref.watch(currentStepProvider)) {
      case 0:
        return _buildStep1DatosPersonales(context);
      case 1:
        return _buildStep2DatosIdentificacion(context);
      case 2:
        return _buildStep3DatosIngreso(context);
      default:
        return _buildStep1DatosPersonales(context);
    }
  }

  Widget _buildStep1DatosPersonales(BuildContext context) {
    return Step1DatosPersonalesWidget(
      currentStep: ref.watch(currentStepProvider),
      onStepChanged: (step) {
        ref.read(currentStepProvider.notifier).state = step;
      },
    );
  }

  Widget _buildStep2DatosIdentificacion(BuildContext context) {
    return Step2DatosIdentificacionWidget(
      currentStep: ref.watch(currentStepProvider),
      onStepChanged: (step) {
        ref.read(currentStepProvider.notifier).state = step;
      },
    );
  }

  Widget _buildStep3DatosIngreso(BuildContext context) {
    return Step3DatosIngresoWidget();
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final registerState = ref.watch(registerProvider);

    if (registerState.isLoading) {
      return LoadingWidget(mensaje: registerState.mensaje);
    }
    return const SizedBox.shrink();
  }

  Widget _buildLogoSection(BuildContext context) {
    return ZoomIn(
      duration: Constantes.standardAnimation,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: const IconoYataWidget(),
        ),
      ),
    );
  }

  Future<void> _solicitarPermisos() async {
    try {
      // Verificar y solicitar permiso de cámara
      final cameraGranted = await _permissionsService.ensureCameraPermission();
      if (!cameraGranted) {
        if (mounted) {
          _mostrarDialogoPermisosDenegados();
        }
        return;
      }

      // Verificar y solicitar permiso de galería/almacenamiento
      final photosGranted = await _permissionsService.ensurePhotosPermission();
      if (!photosGranted) {
        if (mounted) {
          _mostrarDialogoPermisosDenegados();
        }
        return;
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
          'Por favor, active los permisos en la configuración de su dispositivo.',
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
