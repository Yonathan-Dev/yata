import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class ForgotPinScreen extends ConsumerStatefulWidget {
  const ForgotPinScreen({super.key});

  @override
  ConsumerState<ForgotPinScreen> createState() => _ForgotPinScreenState();
}

class _ForgotPinScreenState extends ConsumerState<ForgotPinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _numeroDocumentoController = TextEditingController();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _numeroDocumentoFocusNode = FocusNode();
  final _loginFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _numeroDocumentoController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _numeroDocumentoFocusNode.dispose();
    _loginFocusNode.dispose();
    _passwordFocusNode.dispose();
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
      passwordController: _passwordController,
      loginFocusNode: _loginFocusNode,
      numeroDocumentoFocusNode: _numeroDocumentoFocusNode,
      emailFocusNode: _emailFocusNode,
      passwordFocusNode: _passwordFocusNode,
      onBack: () => context.go('/pin'),
      onContinue: () {
        if (!_formKey.currentState!.validate()) {
          return;
        }

        ref.read(authProvider.notifier).setLogin(_emailController.text);
        ref.read(authProvider.notifier).setPassword(_passwordController.text);
        ref
            .read(authProvider.notifier)
            .setLoading(
              isLoading: true,
              mensaje: 'Solicitando OTP para  de recuperación...',
            );
        //_solicitarRecuperacion();
        _validarUsuario();
      },
      buildContinuarButton: _buildContinuarButton,
      tipoRecuperacion: 'pin',
      titulo: 'Recuperar PIN',
      subtitulo:
          'Por favor, ingresa tu correo electrónico. Te enviaremos un código para recuperar tu PIN.',
    );
  }

  Future<void> _validarUsuario() async {
    try {
      ref.invalidate(loginCorreoProvider);
      final response = await ref.read(loginCorreoProvider.future);

      ref.read(authProvider.notifier).setIdUsuario(response.idUsuario);
      ref.read(authProvider.notifier).setLogin(response.login);

      if (!mounted) return;
      //context.go('/recuperar-pin-otp');
    } catch (error) {
      SnackbarUtil.snackbarNotificationPush(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      ref.read(authProvider.notifier).setLoading(isLoading: false, mensaje: '');
    }
  }

  /*Future<void> _solicitarRecuperacion() async {
    try {
      ref.invalidate(solicitoCambioPinProvider);
      final response = await ref.read(solicitoCambioPinProvider.future);

      await secureStorage.write(key: 'pinTemporary', value: 'true');

      if (!mounted) return;
      SnackbarUtil.snackbarNotificationPush(context, message: response);
      //context.go('/auth');
    } catch (error) {
      SnackbarUtil.snackbarNotificationPush(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      ref.read(authProvider.notifier).setLoading(isLoading: false, mensaje: '');
    }
  }*/

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
