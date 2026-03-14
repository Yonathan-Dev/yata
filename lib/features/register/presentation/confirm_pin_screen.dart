import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class ConfirmPinScreen extends ConsumerStatefulWidget {
  const ConfirmPinScreen({super.key});

  @override
  ConsumerState<ConfirmPinScreen> createState() => _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends ConsumerState<ConfirmPinScreen> {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _codeControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.length == 1 && index == 5) {
      FocusScope.of(context).unfocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _fullCode {
    return _codeControllers.map((c) => c.text).join();
  }

  void _handleContinuar() {
    final code = _fullCode;

    if (code.length < 6) {
      SnackbarUtil.snackbarNotificationPush(
        context,
        message: 'Por favor, ingresa una clave de 6 dígitos',
      );
      return;
    }

    ref.read(registerPinProvider.notifier).setConfirmPin(code);

    if (ref.read(registerPinProvider.notifier).validarPin() == false) {
      SnackbarUtil.snackbarNotificationPush(
        context,
        message: 'Las claves no coinciden, por favor intenta de nuevo',
      );
      return;
    }

    ref.read(registerProvider.notifier).setIsLoading(true);
    ref.read(registerProvider.notifier).setMensaje('Registrando tu cuenta...');

    () async {
      try {
        final response = await ref.read(registrarCuentaProvider.future);
        ref.read(registerProvider.notifier).setIsLoading(false);
        if (response == 'OK') {
          await secureStorage.write(key: 'flagRegistrado', value: 'true');
          if (!mounted) return;
          SnackbarUtil.snackbarNotificationPush(
            context,
            message: 'Cuenta registrada exitosamente',
          );
          context.go('/pin');
        } else {
          if (!mounted) return;
          SnackbarUtil.snackbarError(
            context,
            message: 'Error al registrar la cuenta: $response',
          );
        }
      } catch (e) {
        if (!mounted) return;
        SnackbarUtil.snackbarError(
          context,
          message: 'Error al registrar la cuenta: ${e.toString()}',
        );
      } finally {
        ref.read(registerProvider.notifier).setIsLoading(false);
        ref.read(registerProvider.notifier).setMensaje('');
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Tema.blanco,
        body: Stack(
          children: [
            Column(
              children: [
                SafeArea(bottom: false, child: _buildLogoSection(context)),
                Expanded(child: _buildVioletSection(context)),
              ],
            ),
            _buildLoadingIndicator(context),
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

  Widget _buildLoadingIndicator(BuildContext context) {
    final registerState = ref.watch(registerProvider);

    if (registerState.isLoading) {
      return LoadingWidget(mensaje: registerState.mensaje);
    }
    return const SizedBox.shrink();
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
        // Contenido: Card + Logo debajo
        Positioned(
          top: -60,
          left: 24,
          right: 24,
          child: Column(
            children: [
              _buildVerificationCard(context),
              const SizedBox(height: 24),
              _buildRobotSection(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationCard(BuildContext context) {
    return FadeInUp(
      duration: Constantes.standardAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Tema.blanco,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Tema.negro.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título
              Text(
                'Confirmar contraseña',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Tema.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Crea una clave de 6 dígitos que consideres segura. Sé original',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Tema.negro,
                  height: 1.4,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              _buildCodeInputs(context),
              const SizedBox(height: 32),
              _buildContinuarButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInputs(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        const totalSpacing = spacing * 5;
        final fieldWidth = (constraints.maxWidth - totalSpacing) / 6;

        return Row(
          children: List.generate(6, (index) {
            return Row(
              children: [
                SizedBox(
                  width: fieldWidth,
                  height: 50,
                  child: TextField(
                    controller: _codeControllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    obscureText: true,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Tema.negro,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: const Color(0xFFE0E0E0),
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Tema.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) => _onCodeChanged(value, index),
                  ),
                ),
                if (index < 5) const SizedBox(width: spacing),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildContinuarButton(BuildContext context) {
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
              onPressed: _handleContinuar,
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
    return ZoomIn(
      duration: Constantes.standardAnimation,
      delay: const Duration(milliseconds: 300),
      child: Container(
        width: 80,
        height: 80,
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
