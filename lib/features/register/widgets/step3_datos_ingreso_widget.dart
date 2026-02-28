import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart';

class Step3DatosIngresoWidget extends ConsumerStatefulWidget {
  const Step3DatosIngresoWidget({super.key});

  @override
  ConsumerState<Step3DatosIngresoWidget> createState() =>
      _Step3DatosIngresoWidgetState();
}

class _Step3DatosIngresoWidgetState
    extends ConsumerState<Step3DatosIngresoWidget> {
  bool _acceptTerms = false;
  bool _acceptDataPolicy = false;
  bool _acceptPromotions = false;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Constantes.standardAnimation,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 280,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Tema.blanco, width: 0.5),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    _buildTextFieldWhiteBorder(hint: 'Correo electrónico:'),
                    const SizedBox(height: Constantes.separacion),
                    _buildTextFieldWhiteBorder(
                      hint: 'Confirma tu correo electrónico:',
                    ),
                    const SizedBox(height: Constantes.separacion),
                    _buildTextFieldWhiteBorder(
                      hint: 'Crea tu contraseña',
                      isPassword: true,
                    ),
                    const SizedBox(height: Constantes.separacion),
                    _buildTextFieldWhiteBorder(
                      hint: 'Confirma tu contraseña',
                      isPassword: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Constantes.separacion * 2),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  _buildCheckboxItem(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                      });
                    },
                    text: 'Acepta términos y condiciones',
                  ),
                  const SizedBox(height: 12),
                  _buildCheckboxItem(
                    value: _acceptDataPolicy,
                    onChanged: (value) {
                      setState(() {
                        _acceptDataPolicy = value ?? false;
                      });
                    },
                    text: 'Aceptar política de uso de datos',
                  ),
                  const SizedBox(height: 12),
                  _buildCheckboxItem(
                    value: _acceptPromotions,
                    onChanged: (value) {
                      setState(() {
                        _acceptPromotions = value ?? false;
                      });
                    },
                    text: 'Recibir por correo eletrónico promosiones',
                  ),
                ],
              ),
            ),
            const SizedBox(height: Constantes.separacion * 2),
            Container(
              width: double.infinity,
              height: Constantes.botonHeight,
              margin: const EdgeInsets.symmetric(horizontal: 50),
              child: ElevatedButton(
                onPressed: (_acceptTerms && _acceptDataPolicy)
                    ? () {
                        context.push('/verify-code');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Tema.negro,
                  foregroundColor: Tema.blanco,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Crear cuenta',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Tema.blanco,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Constantes.separacion),
            TextButton(
              onPressed: () {
                // Navegar a login
              },
              child: Text(
                'Ya tienes una cuenta',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Tema.blanco,
                  decoration: TextDecoration.underline,
                  decorationColor: Tema.blanco,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWhiteBorder({
    required String hint,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Tema.blanco,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(color: Tema.negro),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Tema.primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Tema.blanco,
          suffixIcon: isPassword
              ? Icon(Icons.visibility_off, color: Colors.grey[500])
              : null,
        ),
      ),
    );
  }

  Widget _buildCheckboxItem({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String text,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: value ? Tema.negro : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Tema.negro, width: 1),
            ),
            child: value
                ? const Icon(Icons.check, size: 16, color: Tema.primaryColor)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: Tema.blanco),
            ),
          ),
        ],
      ),
    );
  }
}
