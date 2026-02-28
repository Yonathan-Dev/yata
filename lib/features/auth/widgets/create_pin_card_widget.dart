import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class CreatePinCardWidget extends StatelessWidget {
  final List<TextEditingController> codeControllers;
  final List<FocusNode> codeFocusNodes;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final Widget Function(BuildContext, {required VoidCallback onPressed})
  buildContinuarButton;

  const CreatePinCardWidget({
    super.key,
    required this.codeControllers,
    required this.codeFocusNodes,
    required this.onBack,
    required this.onContinue,
    required this.buildContinuarButton,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Constantes.standardAnimation,
      child: Container(
        padding: const EdgeInsets.all(28),
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
            // Botón volver
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Tema.negro),
                onPressed: onBack,
                splashRadius: 24,
                tooltip: 'Volver',
              ),
            ),
            Text(
              'Crea tu contraseña',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Tema.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Crea una clave de 4 dígitos que consideres segura. Sé original',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Tema.negro,
                height: 1.4,
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // Campos de PIN
            buildCodeInputs(
              codeControllers,
              codeFocusNodes,
              obscure: true,
              fillColor: Tema.negro,
              textColor: Tema.blanco,
            ),
            const SizedBox(height: 24),
            buildContinuarButton(
              context,
              onPressed: () {
                final pin = codeControllers.map((c) => c.text).join();
                if (pin.length == 4) {
                  onContinue();
                } else {
                  SnackbarUtil.snackbarError(
                    context,
                    message: 'Ingresa los 4 dígitos de tu contraseña',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCodeInputs(
    List<TextEditingController> controllers,
    List<FocusNode> focusNodes, {
    bool obscure = false,
    Color fillColor = const Color(0xFFE0E0E0),
    Color textColor = Tema.negro,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
            height: 55,
            child: TextField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              obscureText: obscure,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: fillColor,
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
              onChanged: (value) {
                if (value.length == 1 && index < 3) {
                  focusNodes[index + 1].requestFocus();
                }
                if (value.isEmpty && index > 0) {
                  focusNodes[index - 1].requestFocus();
                }
              },
            ),
          ),
        );
      }),
    );
  }
}
