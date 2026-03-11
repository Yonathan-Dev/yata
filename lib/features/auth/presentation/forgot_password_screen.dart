import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _numeroDocumentoController = TextEditingController();
  final _loginController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _numeroDocumentoController.dispose();
    _loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Tema.blanco,
        body: Column(
          children: [
            // Logo superior
            SafeArea(bottom: false, child: _buildLogoSection(context)),
            // Contenido con pasos
            Expanded(child: _buildVioletSection(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection(BuildContext context) {
    return ZoomIn(
      duration: Constantes.standardAnimation,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 100),
          child: const IconoYataWidget(),
        ),
      ),
    );
  }

  Widget _buildVioletSection(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: ConvexCurveClipper(
            screenHeight: screenSize.height,
            screenWidth: screenSize.width,
          ),
          child: Container(width: double.infinity, color: Tema.primaryColor),
        ),
        Positioned(
          top: -50,
          left: 24,
          right: 24,
          child: Column(
            children: [
              _buildRecuperarCard(context),
              const SizedBox(height: 24),
              _buildRobotSection(context),
            ],
          ),
        ),
        _buildLoadingIndicator(context),
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

  Widget _buildRecuperarCard(BuildContext context) {
    return RecuperarCardWidget(
      loginController: _loginController,
      numeroDocumentoController: _numeroDocumentoController,
      emailController: _emailController,
      onBack: () => context.go('/auth'),
      onContinue: () {
        if (_loginController.text.isEmpty) {
          SnackbarUtil.snackbarNotificationPush(
            context,
            message: 'Ingresa tu logín',
          );
          return;
        }
        if (_numeroDocumentoController.text.isEmpty) {
          SnackbarUtil.snackbarNotificationPush(
            context,
            message: 'Ingresa tu número de documento',
          );
          return;
        }
        if (_emailController.text.isEmpty) {
          SnackbarUtil.snackbarNotificationPush(
            context,
            message: 'Ingresa tu correo electrónico',
          );
          return;
        }
        if (!RegExp(
          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        ).hasMatch(_loginController.text)) {
          SnackbarUtil.snackbarNotificationPush(
            context,
            message: 'Ingresa un logín válido',
          );
          return;
        }
        if (!RegExp(
          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        ).hasMatch(_emailController.text)) {
          SnackbarUtil.snackbarNotificationPush(
            context,
            message: 'Ingresa un correo electrónico válido',
          );
          return;
        }
        if (_loginController.text.toLowerCase() !=
            _emailController.text.toLowerCase()) {
          SnackbarUtil.snackbarNotificationPush(
            context,
            message: 'El logín debe coincidir con el correo electrónico',
          );
          return;
        }

        ref.read(registerProvider.notifier).setCorreo(_loginController.text);
        ref
            .read(registerProvider.notifier)
            .setNumeroDocumento(_numeroDocumentoController.text);
        ref
            .read(authProvider.notifier)
            .setLoading(
              isLoading: true,
              mensaje: 'Solicitando contraseña de recuperación...',
            );
        // Invalidar el provider para forzar una nueva ejecución
        ref.invalidate(restaurarClaveProvider);
        _solicitarRecuperacion();
      },
      buildContinuarButton: _buildContinuarButton,
    );
  }

  Future<void> _solicitarRecuperacion() async {
    try {
      final response = await ref.read(restaurarClaveProvider.future);
      if (!mounted) return;
      ref.read(authProvider.notifier).setLoading(isLoading: false, mensaje: '');
      SnackbarUtil.snackbarNotificationPush(context, message: response);
      context.go('/auth');
    } catch (error) {
      if (!mounted) return;
      ref.read(authProvider.notifier).setLoading(isLoading: false, mensaje: '');
      SnackbarUtil.snackbarNotificationPush(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Widget _buildContinuarButton(
    BuildContext context, {
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: Constantes.botonHeightMedium,
      child: Stack(
        children: [
          // Fondo con gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Tema.negro, Tema.primaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Botón transparente encima
          Positioned.fill(
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                'Continuar',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Tema.blanco,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRobotSection(BuildContext context) {
    return RobotSectionWidget();
  }
}
