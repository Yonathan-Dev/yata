import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key});

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  late List<String> _shuffledNumbers;

  @override
  void initState() {
    super.initState();
    _shuffleNumbers();
  }

  void _shuffleNumbers() {
    _shuffledNumbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    _shuffledNumbers.shuffle(Random());
  }

  void _onNumberPressed(String number) {
    final enteredPin = ref.read(pinProvider.notifier).state;
    if (enteredPin.length < 6) {
      ref.read(pinProvider.notifier).state = enteredPin + number;

      if (enteredPin.length + 1 == 6) {
        ref
            .read(authProvider.notifier)
            .setLoading(isLoading: true, mensaje: 'Verificando...');
        () async {
          try {
            final response = await ref.read(loginPinProvider.future);
            if (response.requiereVerificacion) {
              if (!mounted) return;
              SnackbarUtil.snackbarNotificationPush(
                context,
                message: response.mensajeVerificacion,
              );
              await secureStorage.write(
                key: 'verificationToken',
                value: response.verificationToken,
              );
              if (!mounted) return;
              context.push('/verification-otp');
              return;
            }

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
            await secureStorage.write(
              key: 'userName',
              value: response.apellidosyNombres,
            );
            await secureStorage.write(key: 'userCorreo', value: response.login);
            await secureStorage.write(key: 'pin', value: ref.read(pinProvider));
            await secureStorage.write(key: 'biometricEnabled', value: 'true');

            if (!mounted) return;
            context.go('/home');
            SnackbarUtil.snackbarNotificationPush(
              context,
              message: '¡Bienvenido, ${response.apellidosyNombres}!',
            );
          } catch (error) {
            if (!mounted) return;
            SnackbarUtil.snackbarError(context, message: error.toString());
            ref.read(pinProvider.notifier).state = '';
          } finally {
            _shuffleNumbers();
            ref.read(pinProvider.notifier).state = '';
            ref
                .read(authProvider.notifier)
                .setLoading(isLoading: false, mensaje: '');
          }
        }();
      }
    }
  }

  void _onDeletePressed() {
    final enteredPin = ref.read(pinProvider.notifier).state;
    if (enteredPin.isNotEmpty) {
      ref.read(pinProvider.notifier).state = enteredPin.substring(
        0,
        enteredPin.length - 1,
      );
    }
  }

  void _onBiometricPressed() async {
    final biometricNotifier = ref.read(biometricProvider.notifier);
    await biometricNotifier.refresh();
    final biometricState = ref.read(biometricProvider);

    if (!biometricState.isEnabled) {
      if (!mounted) return;
      SnackbarUtil.snackbarInfo(
        context,
        message: 'Primero ingresa con tu PIN para activar la huella',
      );
      return;
    }

    if (!biometricState.isSupported) {
      if (!mounted) return;
      SnackbarUtil.snackbarError(
        context,
        message: 'Tu dispositivo no soporta autenticación biométrica',
      );
      return;
    }

    final resultado = await biometricNotifier.autenticarYObtenerCredenciales();

    if (!mounted) return;

    final error = ref.read(biometricProvider).error;
    if (error != null) {
      SnackbarUtil.snackbarError(context, message: error);
      return;
    }

    if (resultado.success &&
        resultado.correo != null &&
        resultado.pin != null) {
      ref.read(registerProvider.notifier).setCorreo(resultado.correo!);
      ref.read(pinProvider.notifier).state = resultado.pin!;

      ref
          .read(authProvider.notifier)
          .setLoading(isLoading: true, mensaje: 'Verificando...');

      try {
        final response = await ref.read(loginPinProvider.future);
        if (response.requiereVerificacion) {
          if (!mounted) return;
          SnackbarUtil.snackbarInfo(
            context,
            message: response.mensajeVerificacion,
          );
          await secureStorage.write(
            key: 'verificationToken',
            value: response.verificationToken,
          );
          if (!mounted) return;
          context.push('/verification-otp');
          return;
        }

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
        await secureStorage.write(key: 'tokenType', value: response.tokenType);
        await secureStorage.write(
          key: 'userName',
          value: response.apellidosyNombres,
        );

        if (!mounted) return;
        context.go('/home');
        SnackbarUtil.snackbarSuccess(
          context,
          message: '¡Bienvenido, ${response.apellidosyNombres}!',
        );
      } catch (error) {
        if (mounted) {
          SnackbarUtil.snackbarError(context, message: error.toString());
        }
      } finally {
        ref.read(pinProvider.notifier).state = '';
        ref
            .read(authProvider.notifier)
            .setLoading(isLoading: false, mensaje: '');
      }
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
                SafeArea(bottom: false, child: _buildQRSection(context)),
                Expanded(child: _buildVioletSection(context)),
              ],
            ),
            _buildLoadingIndicator(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQRSection(BuildContext context) {
    return ZoomIn(
      duration: Constantes.standardAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Stack(
          children: [
            Center(
              child: QrImageView(
                data: 'yata-payment-user-id-123456',
                version: QrVersions.auto,
                size: 180,
                backgroundColor: Tema.blanco,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Tema.negro,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Tema.negro,
                ),
              ),
            ),
            // Icono robot en la esquina superior derecha
            Positioned(top: 0, right: 0, child: _buildRobotIcon()),
          ],
        ),
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

  Widget _buildRobotIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Tema.blanco,
        shape: BoxShape.circle,
        border: Border.all(color: Tema.primaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Tema.negro.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Image.asset('assets/iconos/icono.png', fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildVioletSection(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return ClipPath(
      clipper: ConvexCurveClipper(
        screenHeight: screenSize.height,
        screenWidth: screenSize.width,
      ),
      child: Container(
        width: double.infinity,
        color: Tema.primaryColor,
        child: Column(
          children: [
            const SizedBox(height: 60),
            _buildGreeting(context),
            const SizedBox(height: 24),
            Text(
              'Ingresa tu clave',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Tema.blanco,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildPinIndicators(),
            Expanded(child: _buildNumericKeyboard(context)),
            _buildForgotButton(context),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    return FadeInDown(
      duration: Constantes.standardAnimation,
      child: Column(
        children: [
          Text(
            '¡Hola,',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Tema.blanco,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            'Bienvenido!',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Tema.blanco,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinIndicators() {
    final enteredPin = ref.watch(pinProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final isFilled = index < enteredPin.length;
        return Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? Tema.blanco : Colors.transparent,
            border: Border.all(color: Tema.blanco, width: 2),
          ),
        );
      }),
    );
  }

  Widget _buildNumericKeyboard(BuildContext context) {
    return FadeInUp(
      duration: Constantes.standardAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fila 1: posiciones 0, 1, 2
            _buildKeyboardRow([
              _shuffledNumbers[0],
              _shuffledNumbers[1],
              _shuffledNumbers[2],
            ]),
            const SizedBox(height: 12),
            // Fila 2: posiciones 3, 4, 5
            _buildKeyboardRow([
              _shuffledNumbers[3],
              _shuffledNumbers[4],
              _shuffledNumbers[5],
            ]),
            const SizedBox(height: 12),
            // Fila 3: posiciones 6, 7, 8
            _buildKeyboardRow([
              _shuffledNumbers[6],
              _shuffledNumbers[7],
              _shuffledNumbers[8],
            ]),
            const SizedBox(height: 12),
            // Fila 4: huella, posición 9, borrar
            _buildLastRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) => _buildKeyButton(number)).toList(),
    );
  }

  Widget _buildLastRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Botón de huella digital sin fondo
        _buildSpecialButton(
          child: Container(
            decoration: BoxDecoration(
              color: Tema.blanco.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(Icons.fingerprint, color: Tema.blanco, size: 36),
          ),
          onTap: _onBiometricPressed,
          noBackground: true,
        ),
        // Último número
        _buildKeyButton(_shuffledNumbers[9]),
        _buildSpecialButton(
          child: Container(
            decoration: BoxDecoration(
              color: Tema.blanco.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(Icons.backspace_outlined, color: Tema.blanco, size: 32),
          ),
          onTap: _onDeletePressed,
          noBackground: true,
        ),
      ],
    );
  }

  Widget _buildKeyButton(String number) {
    return GestureDetector(
      onTap: () => _onNumberPressed(number),
      child: Container(
        width: 70,
        height: 55,
        decoration: BoxDecoration(
          color: Tema.blanco,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Tema.negro.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Tema.negro,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialButton({
    required Widget child,
    required VoidCallback onTap,
    bool noBackground = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 55,
        decoration: noBackground
            ? null
            : BoxDecoration(
                color: Tema.blanco,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Tema.negro.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
        child: Center(child: child),
      ),
    );
  }

  Widget _buildForgotButton(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        'Olvido o cambio de clave',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Tema.blanco,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
