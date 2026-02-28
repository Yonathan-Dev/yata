//crea un EmailCardWidget que extienda StatelessWidget y tenga un String email como parametro requerido, el widget debe mostrar el email en un Card con un icono de correo a la izquierda del email
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../core/app_exports.dart';

class EmailCardWidget extends StatelessWidget {
  final TextEditingController emailController;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final Widget Function(BuildContext, {required VoidCallback onPressed})
  buildContinuarButton;

  const EmailCardWidget({
    super.key,
    required this.emailController,
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
              'Recuperar contraseña',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Tema.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ingresa tu correo electrónico para enviarte un código de verificación',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Tema.negro,
                height: 1.4,
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Correo electrónico',
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                prefixIcon: const Icon(Icons.email_outlined, color: Tema.gris),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            buildContinuarButton(context, onPressed: onContinue),
          ],
        ),
      ),
    );
  }
}
