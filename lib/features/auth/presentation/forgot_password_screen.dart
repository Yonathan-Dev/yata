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
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _numeroDocumentoController = TextEditingController();
  final _loginController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _numeroDocumentoFocusNode = FocusNode();
  final _loginFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _numeroDocumentoController.dispose();
    _loginController.dispose();
    _emailFocusNode.dispose();
    _numeroDocumentoFocusNode.dispose();
    _loginFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Tema.blanco,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(bottom: false, child: _buildLogoSection(context)),
              _buildVioletSection(context),
            ],
          ),
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
    return SizedBox(
      height: screenSize.height * 0.75,
      child: Stack(
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
      ),
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
      formKey: _formKey,
      loginController: _loginController,
      numeroDocumentoController: _numeroDocumentoController,
      emailController: _emailController,
      loginFocusNode: _loginFocusNode,
      numeroDocumentoFocusNode: _numeroDocumentoFocusNode,
      emailFocusNode: _emailFocusNode,
      onBack: () => context.go('/auth'),
      onContinue: () {
        if (!_formKey.currentState!.validate()) {
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
        _solicitarRecuperacion();
      },
      buildContinuarButton: _buildContinuarButton,
    );
  }

  Future<void> _solicitarRecuperacion() async {
    try {
      ref.invalidate(restaurarClaveProvider);
      final response = await ref.read(restaurarClaveProvider.future);

      await secureStorage.write(key: 'passwordTemporary', value: 'true');

      if (!mounted) return;
      SnackbarUtil.snackbarNotificationPush(context, message: response);
      context.go('/auth');
    } catch (error) {
      SnackbarUtil.snackbarNotificationPush(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      ref.read(authProvider.notifier).setLoading(isLoading: false, mensaje: '');
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
