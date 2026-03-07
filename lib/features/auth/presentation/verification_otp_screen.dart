import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class VerificationOtpScreen extends ConsumerStatefulWidget {
  const VerificationOtpScreen({super.key});

  @override
  ConsumerState<VerificationOtpScreen> createState() =>
      _VerificationOtpScreenState();
}

class _VerificationOtpScreenState extends ConsumerState<VerificationOtpScreen> {
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
    if (code.length == 6) {
      ref.read(verifyCodeProvider.notifier).setIsLoading(true);
      ref.read(verifyCodeProvider.notifier).setMensaje('Verificando código...');
      ref.read(verifyCodeProvider.notifier).setCodigoOtp(code);

      ref
          .read(loginCodigoOtpProvider.future)
          .then((response) async {
            await secureStorage.write(
              key: 'accessToken',
              value: response.accessToken,
            );
            await secureStorage.write(
              key: 'refreshToken',
              value: response.refreshToken,
            );
            await secureStorage.write(
              key: 'expiresAt',
              value: response.expiresAt.toIso8601String(),
            );
            await secureStorage.write(
              key: 'tokenType',
              value: response.tokenType,
            );
            if (mounted) {
              SnackbarUtil.snackbarNotificationPush(
                context,
                message: 'Código verificado correctamente',
              );
            }
            if (mounted) {
              context.go('/pin');
            }
          })
          .catchError((error) {
            if (mounted) {
              SnackbarUtil.snackbarError(context, message: error.toString());
            }
            if (mounted) {
              SnackbarUtil.snackbarError(context, message: error.toString());
            }
          })
          .whenComplete(() {
            ref.read(verifyCodeProvider.notifier).resetEstado();
          });
    } else {
      SnackbarUtil.snackbarNotificationPush(
        context,
        message: 'Por favor ingresa los 6 dígitos',
      );
    }
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
    final verifyCodeState = ref.watch(verifyCodeProvider);

    if (verifyCodeState.isLoading) {
      return LoadingWidget(mensaje: verifyCodeState.mensaje);
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
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Tema.negro.withValues(alpha: 0.3),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título
              Text(
                'Revisa tu correo',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Tema.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Descripción
              Text(
                'Ingresa el código de verificación que hemos enviado a tu correo, sino lo encuentras revisa tu bandeja de spam.',
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: fieldWidth,
              height: 50,
              child: TextField(
                controller: _codeControllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Tema.blanco,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Tema.negro,
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
