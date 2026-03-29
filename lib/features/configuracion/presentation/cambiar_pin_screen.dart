import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart' hide AppBarWidget;
import '../../../shared/shared_exports.dart';

class CambiarPinScreen extends ConsumerStatefulWidget {
  const CambiarPinScreen({super.key});

  @override
  ConsumerState<CambiarPinScreen> createState() => _CambiarPinScreenState();
}

class _CambiarPinScreenState extends ConsumerState<CambiarPinScreen> {
  // Paso actual: 0 = PIN actual, 1 = nuevo PIN, 2 = confirmar PIN
  int _step = 0;

  final List<List<TextEditingController>> _controllers = List.generate(
    3,
    (_) => List.generate(6, (_) => TextEditingController()),
  );
  final List<List<FocusNode>> _focusNodes = List.generate(
    3,
    (_) => List.generate(6, (_) => FocusNode()),
  );
  final List<List<bool>> _filledFields = List.generate(
    3,
    (_) => List.generate(6, (_) => false),
  );

  static const _stepTitles = ['PIN actual', 'Nuevo PIN', 'Confirmar PIN'];
  static const _stepSubtitles = [
    'Ingresa tu PIN actual de 6 dígitos',
    'Define un nuevo PIN seguro de 6 dígitos',
    'Vuelve a ingresar tu nuevo PIN para confirmar',
  ];
  static const _stepIcons = [
    Icons.lock_outline_rounded,
    Icons.lock_open_rounded,
    Icons.lock_person_outlined,
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      FocusScope.of(context).unfocus();
    });
    for (int s = 0; s < 3; s++) {
      for (int i = 0; i < 6; i++) {
        final step = s;
        final idx = i;
        _controllers[s][i].addListener(() {
          setState(() {
            _filledFields[step][idx] = _controllers[step][idx].text.isNotEmpty;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    for (final group in _controllers) {
      for (final c in group) {
        c.dispose();
      }
    }
    for (final group in _focusNodes) {
      for (final f in group) {
        f.dispose();
      }
    }
    super.dispose();
  }

  void _onDigitChanged(String value, int step, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[step][index + 1].requestFocus();
    } else if (value.length == 1 && index == 5) {
      FocusScope.of(context).unfocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[step][index - 1].requestFocus();
    }
  }

  String _getPinForStep(int step) =>
      _controllers[step].map((c) => c.text).join();

  int get _filledCount => _filledFields[_step].where((f) => f).length;
  bool get _stepComplete => _filledCount == 6;

  void _clearStep(int step) {
    for (int i = 0; i < 6; i++) {
      _controllers[step][i].clear();
      setState(() => _filledFields[step][i] = false);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[step][0].requestFocus();
    });
  }

  Future<void> _handleContinuar() async {
    if (!_stepComplete) return;

    if (_step < 2) {
      for (final node in _focusNodes[_step]) {
        node.unfocus();
      }
      setState(() => _step++);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[_step][0].requestFocus();
      });
      return;
    }

    final pinNuevo = _getPinForStep(1);
    final pinConfirmar = _getPinForStep(2);

    if (pinNuevo != pinConfirmar) {
      SnackbarUtil.snackbarNotificationPush(
        context,
        message: 'Los nuevos PIN no coinciden',
      );
      _clearStep(2);
      return;
    }

    try {
      ref
          .read(cambiarPinProvider.notifier)
          .setPinActual(_getPinForStep(0).trim());
      ref.read(cambiarPinProvider.notifier).setPinNuevo(pinConfirmar.trim());
      ref.read(cambiarPinProvider.notifier).setIsLoading(true);
      ref.read(cambiarPinProvider.notifier).setMensaje('Actualizando PIN...');
      ref.invalidate(solicitarCambioPinProvider);
      await ref.read(solicitarCambioPinProvider.future);
      if (!mounted) return;
      SnackbarUtil.snackbarNotificationPush(
        context,
        message: 'PIN actualizado exitosamente',
      );
      await ref.read(cambiarPinProvider.notifier).logout();
    } catch (e) {
      if (!mounted) return;
      SnackbarUtil.snackbarError(context, message: e.toString());
    } finally {
      ref.read(cambiarPinProvider.notifier).setIsLoading(false);
      ref.read(cambiarPinProvider.notifier).setMensaje('');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(inactivityProvider);
    return InactivityListener(
      child: Scaffold(
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
            onPressed: () {
              if (_step > 0) {
                for (final node in _focusNodes[_step]) {
                  node.unfocus();
                }
                setState(() => _step--);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _focusNodes[_step][0].requestFocus();
                });
              } else {
                context.go('/home');
              }
            },
            icon: const Icon(
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
        children: [
          SizedBox(height: screenSize.height * 0.03),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: Container(
              key: ValueKey(_step),
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
              child: Icon(_stepIcons[_step], color: Tema.blanco, size: 32),
            ),
          ),

          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Column(
              key: ValueKey('title_$_step'),
              children: [
                Text(
                  _stepTitles[_step],
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Tema.blanco,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _stepSubtitles[_step],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Tema.blanco.withValues(alpha: 0.75),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenSize.height * 0.038),
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            delay: const Duration(milliseconds: 100),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Tema.blanco,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Indicador de pasos
                  _buildStepIndicator(context),
                  const SizedBox(height: 24),
                  Text(
                    'Ingresa los 6 dígitos',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Tema.primaryColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildPinInputs(context, _step),
                  const SizedBox(height: 14),
                  _buildProgressBar(context),
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
                        'Solo se permiten dígitos numéricos',
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

                  // Opción de borrar campos
                  if (_filledCount > 0) ...[
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () => _clearStep(_step),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[400],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.backspace_outlined,
                              size: 14,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Borrar y reintentar',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context) {
    const labels = ['PIN actual', 'Nuevo PIN', 'Confirmar'];
    return Row(
      children: List.generate(3, (index) {
        final isDone = index < _step;
        final isActive = index == _step;
        return Expanded(
          child: Row(
            children: [
              if (index > 0)
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 2,
                    color: isDone || isActive
                        ? Tema.primaryColor
                        : Colors.grey[200],
                  ),
                ),
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone
                          ? Colors.green[400]
                          : isActive
                          ? Tema.primaryColor
                          : Colors.grey[200],
                    ),
                    child: Center(
                      child: isDone
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 14,
                            )
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? Colors.white
                                    : Colors.grey[400],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 9.5,
                      color: isActive
                          ? Tema.primaryColor
                          : isDone
                          ? Colors.green[400]
                          : Colors.grey[400],
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
              if (index < 2)
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 2,
                    color: index < _step ? Tema.primaryColor : Colors.grey[200],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPinInputs(BuildContext context, int step) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        const totalSpacing = spacing * 5;
        final fieldWidth = (constraints.maxWidth - totalSpacing) / 6;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            final isFilled = _filledFields[step][index];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: fieldWidth,
              height: 54,
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
                controller: _controllers[step][index],
                focusNode: _focusNodes[step][index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                obscureText: true, // ocultar dígitos por seguridad
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
                onChanged: (value) => _onDigitChanged(value, step, index),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final isComplete = _filledCount == 6;
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
            if (isComplete)
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 13,
                    color: Colors.green[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Completo',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green[400],
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
              isComplete ? Colors.green[400]! : Tema.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinuarButton(BuildContext context) {
    final isLast = _step == 2;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: _stepComplete ? 1.0 : 0.5,
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
            boxShadow: _stepComplete
                ? [
                    BoxShadow(
                      color: Tema.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: ElevatedButton(
            onPressed: _stepComplete ? _handleContinuar : null,
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
                Icon(
                  isLast
                      ? Icons.check_circle_outline_rounded
                      : Icons.arrow_forward_rounded,
                  color: Tema.blanco,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  isLast ? 'Guardar PIN' : 'Continuar',
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
    final state = ref.watch(cambiarPinProvider);
    if (state.isLoading) return LoadingWidget(mensaje: state.mensaje);
    return const SizedBox.shrink();
  }
}
