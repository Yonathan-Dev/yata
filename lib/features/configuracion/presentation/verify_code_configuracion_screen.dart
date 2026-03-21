import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class VerifyCodeConfiguracionScreen extends ConsumerStatefulWidget {
  const VerifyCodeConfiguracionScreen({super.key});

  @override
  ConsumerState<VerifyCodeConfiguracionScreen> createState() =>
      _VerifyCodeConfiguracionScreenState();
}

class _VerifyCodeConfiguracionScreenState
    extends ConsumerState<VerifyCodeConfiguracionScreen> {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      final index = i;
      _codeControllers[i].addListener(() {
        ref.read(filledFieldsProvider.notifier).update((state) {
          final newState = List<bool>.from(state);
          newState[index] = _codeControllers[index].text.isNotEmpty;
          return newState;
        });
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _codeControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
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

  String get _fullCode => _codeControllers.map((c) => c.text).join();

  int get _filledCount =>
      ref.watch(filledFieldsProvider).where((f) => f).length;

  Future<void> _handleContinuar() async {
    final code = _fullCode;
    if (code.length != 6) {
      SnackbarUtil.snackbarNotificationPush(
        context,
        message: 'Por favor ingresa un código de 6 dígitos',
      );
      return;
    }

    ref.read(cambiarContrasenaProvider.notifier).setCodigoOtp(code);
    try {
      ref.read(cambiarContrasenaProvider.notifier).setIsLoading(true);

      ref
          .read(cambiarContrasenaProvider.notifier)
          .setMensaje('Verificando código...');
      final response = await ref.read(
        enviarVerificacionCodigoOTPProvider.future,
      );
      if (!mounted) return;
      SnackbarUtil.snackbarNotificationPush(context, message: response);
      context.push('/configuracion/cambiar-contrasena');
    } catch (e) {
      SnackbarUtil.snackbarError(
        context,
        message: 'Error al verificar el código:',
      );
    } finally {
      ref.read(cambiarContrasenaProvider.notifier).setIsLoading(false);
      ref.read(cambiarContrasenaProvider.notifier).setMensaje('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tema.blanco,
      body: Stack(
        children: [
          _buildBackground(context),
          SafeArea(
            child: Column(
              children: [
                _buildCustomAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: _buildContent(context),
                  ),
                ),
              ],
            ),
          ),
          _buildLoadingIndicator(context),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        ClipPath(
          clipper: ConvexCurveClipper(
            screenHeight: screenSize.height,
            screenWidth: screenSize.width,
          ),
          child: Container(width: double.infinity, color: Tema.primaryColor),
        ),
        Positioned(
          top: -40,
          right: -40,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Tema.blanco.withValues(alpha: 0.06),
            ),
          ),
        ),
        Positioned(
          top: 60,
          left: -30,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Tema.blanco.withValues(alpha: 0.05),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Tema.primaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: screenSize.height * 0.03),
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Tema.blanco.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Tema.blanco.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.verified_outlined,
                  color: Tema.blanco,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeInDown(
            duration: const Duration(milliseconds: 550),
            delay: const Duration(milliseconds: 80),
            child: Column(
              children: [
                Text(
                  'Revisa tu correo',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Tema.blanco,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ingresa el código de 6 dígitos enviado\na tu correo electrónico',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Tema.blanco,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenSize.height * 0.045),
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            delay: const Duration(milliseconds: 150),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Tema.blanco,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Tema.primaryColor.withValues(alpha: 0.15),
                    blurRadius: 32,
                    spreadRadius: 0,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: Tema.negro.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCodeInputs(context),
                  const SizedBox(height: 12),
                  _buildProgressIndicator(context),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 13,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Si no lo encuentras, revisa tu carpeta de spam',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey[400],
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildContinuarButton(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 300),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Tema.blanco.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Tema.blanco.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/iconos/icono.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
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
            final isFilled = ref.watch(filledFieldsProvider)[index];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: fieldWidth,
              height: 52,
              decoration: BoxDecoration(
                color: isFilled
                    ? Tema.primaryColor.withValues(alpha: 0.08)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isFilled
                      ? Tema.primaryColor.withValues(alpha: 0.6)
                      : Colors.grey[200]!,
                  width: isFilled ? 2 : 1.5,
                ),
              ),
              child: TextField(
                controller: _codeControllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Tema.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  counterText: '',
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
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

  Widget _buildProgressIndicator(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$_filledCount de 6 dígitos',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[400],
                letterSpacing: 0.2,
              ),
            ),
            if (_filledCount == 6)
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 13,
                    color: Tema.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Código completo',
                    style: TextStyle(
                      fontSize: 11,
                      color: Tema.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _filledCount / 6,
            minHeight: 3,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              _filledCount == 6 ? Colors.green[400]! : Tema.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinuarButton(BuildContext context) {
    final isReady = _filledCount == 6;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: isReady ? 1.0 : 0.55,
      child: SizedBox(
        width: double.infinity,
        height: Constantes.botonHeightMedium,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Tema.primaryColor,
                Tema.primaryColor.withValues(alpha: 0.82),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: ElevatedButton(
            onPressed: isReady ? _handleContinuar : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_forward_rounded, color: Tema.blanco, size: 18),
                const SizedBox(width: 10),
                Text(
                  'Continuar',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Tema.blanco,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final state = ref.watch(cambiarContrasenaProvider);
    if (state.isLoading) {
      return LoadingWidget(mensaje: state.mensaje);
    }
    return const SizedBox.shrink();
  }
}
