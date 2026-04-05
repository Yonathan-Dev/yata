import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class ResultadoQrScreen extends ConsumerStatefulWidget {
  final String qrData;

  const ResultadoQrScreen({super.key, required this.qrData});

  @override
  ConsumerState<ResultadoQrScreen> createState() => _ResultadoQrScreenState();
}

class _ResultadoQrScreenState extends ConsumerState<ResultadoQrScreen> {
  final montoController = TextEditingController();
  final montoFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    montoController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    montoController.removeListener(_updateButtonState);
    montoController.dispose();
    montoFocusNode.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final text = montoController.text.trim();
    final double? monto = double.tryParse(text);
    ref.read(isButtonEnabled.notifier).state =
        text.isNotEmpty && monto != null && monto > 0;
  }

  String _getNombrePersona() {
    // Aquí podrías parsear el widget.qrData para obtener el nombre
    // Por ahora usamos un nombre de ejemplo basado en el QR
    return 'Yonathan G.';
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(inactivityProvider);
    final nombrePersona = _getNombrePersona();

    return InactivityListener(
      child: Scaffold(
        backgroundColor: Tema.blanco,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Nombre de la persona
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      nombrePersona,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Tema.negro,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Etiqueta "Monto a pagar"
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 200),
                    child: const Text(
                      'Monto a pagar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Tema.negro,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campo de monto con s/. ya presente
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 400),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6D9FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            's/. ',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                              color: Tema.negro,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: montoController,
                              focusNode: montoFocusNode,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color: Tema.negro,
                              ),
                              decoration: const InputDecoration(
                                hintText: '0.00',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Botones
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 600),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ref.watch(isButtonEnabled)
                                  ? Tema.primaryColor
                                  : Tema.primaryColor.withValues(alpha: 0.4),
                              foregroundColor: Tema.blanco,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: ref.watch(isButtonEnabled)
                                ? () {
                                    context.go(
                                      '/pago-exitoso',
                                      extra: {
                                        'metodoPago': 'QR',
                                        'screen': '/home',
                                      },
                                    );
                                  }
                                : null,
                            child: const Text(
                              '¡Yata!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Tema.negro,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              side: const BorderSide(
                                color: Tema.negro,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              context.go('/home');
                            },
                            child: const Text(
                              'Regresar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
