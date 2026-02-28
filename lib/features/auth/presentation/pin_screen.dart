import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/app_exports.dart';

class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key});

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  String _enteredPin = '';
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
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += number;
      });

      // Si completó los 4 dígitos, ir al home
      if (_enteredPin.length == 4) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            context.go('/home');
          }
        });
      }
    }
  }

  void _onDeletePressed() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  void _onBiometricPressed() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tema.blanco,
      body: Column(
        children: [
          // Parte superior blanca con QR e icono
          SafeArea(bottom: false, child: _buildQRSection(context)),
          // Parte violeta con teclado
          Expanded(child: _buildVioletSection(context)),
        ],
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
            // QR centrado
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
    return ClipPath(
      clipper: _TopOvalCurveClipper(),
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
            const SizedBox(height: 20),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isFilled = index < _enteredPin.length;
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
        // Botón borrar sin fondo
        _buildSpecialButton(
          child: Container(
            decoration: BoxDecoration(
              color: Tema.blanco.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(Icons.close, color: Tema.blanco, size: 32),
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
        'OLVIDO O CAMBIO DE CLAVE',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Tema.blanco,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

// Clipper para curva ovalada superior
class _TopOvalCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, size.height);
    path.lineTo(0, 80);

    // Curva ovalada suave
    path.cubicTo(0, 0, size.width, 0, size.width, 80);

    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
