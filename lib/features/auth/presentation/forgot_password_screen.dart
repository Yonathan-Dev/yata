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
  int _currentStep = 0;
  final _emailController = TextEditingController();
  final List<TextEditingController> _codeControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _pinControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _confirmPinControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _codeFocusNodes = List.generate(4, (_) => FocusNode());
  final List<FocusNode> _pinFocusNodes = List.generate(4, (_) => FocusNode());
  final List<FocusNode> _confirmPinFocusNodes = List.generate(
    4,
    (_) => FocusNode(),
  );

  @override
  void dispose() {
    _emailController.dispose();
    for (final c in _codeControllers) {
      c.dispose();
    }
    for (final c in _pinControllers) {
      c.dispose();
    }
    for (final c in _confirmPinControllers) {
      c.dispose();
    }
    for (final n in _codeFocusNodes) {
      n.dispose();
    }
    for (final n in _pinFocusNodes) {
      n.dispose();
    }
    for (final n in _confirmPinFocusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      context.go('/pin');
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      context.pop();
    }
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
        // Card centrada
        Positioned(
          top: -50,
          left: 24,
          right: 24,
          child: Column(
            children: [
              _buildCurrentStepCard(context),
              const SizedBox(height: 24),
              _buildRobotSection(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStepCard(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return _buildEmailCard(context);
      case 1:
        return _buildVerifyCodeCard(context);
      case 2:
        return _buildCreatePinCard(context);
      case 3:
        return _buildConfirmPinCard(context);
      default:
        return _buildEmailCard(context);
    }
  }

  // PASO 1: Ingresar correo
  Widget _buildEmailCard(BuildContext context) {
    return EmailCardWidget(
      emailController: _emailController,
      onBack: _previousStep,
      onContinue: () {
        if (_emailController.text.isNotEmpty) {
          _nextStep();
        } else {
          SnackbarUtil.snackbarError(
            context,
            message: 'Ingresa tu correo electrónico',
          );
        }
      },
      buildContinuarButton: _buildContinuarButton,
    );
  }

  // PASO 2: Verificar código
  Widget _buildVerifyCodeCard(BuildContext context) {
    return VerifyCodeCardWidget(
      codeControllers: _codeControllers,
      codeFocusNodes: _codeFocusNodes,
      onBack: _previousStep,
      onContinue: _nextStep,
      buildContinuarButton: _buildContinuarButton,
    );
  }

  // PASO 3: Crear PIN
  Widget _buildCreatePinCard(BuildContext context) {
    return CreatePinCardWidget(
      codeControllers: _pinControllers,
      codeFocusNodes: _pinFocusNodes,
      onBack: _previousStep,
      onContinue: _nextStep,
      buildContinuarButton: _buildContinuarButton,
    );
  }

  // PASO 4: Confirmar PIN
  Widget _buildConfirmPinCard(BuildContext context) {
    return ConfirmPinCardWidget(
      pinControllers: _pinControllers,
      confirmPinControllers: _confirmPinControllers,
      confirmPinFocusNodes: _confirmPinFocusNodes,
      onBack: _previousStep,
      onContinue: _nextStep,
      buildContinuarButton: _buildContinuarButton,
    );
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
