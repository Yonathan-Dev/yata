import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_exports.dart';

class Step1DatosPersonalesWidget extends ConsumerStatefulWidget {
  final int currentStep;
  final void Function(int)? onStepChanged;
  const Step1DatosPersonalesWidget({
    super.key,
    required this.currentStep,
    this.onStepChanged,
  });

  @override
  ConsumerState<Step1DatosPersonalesWidget> createState() =>
      _Step1DatosPersonalesWidgetState();
}

class _Step1DatosPersonalesWidgetState
    extends ConsumerState<Step1DatosPersonalesWidget> {
  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Constantes.standardAnimation,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: Tema.primaryColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Tema.blanco, width: 0.5),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    _buildTextField(hint: 'Nombres'),
                    const SizedBox(height: Constantes.separacion),
                    _buildTextField(hint: 'Apellidos'),
                    const SizedBox(height: Constantes.separacion),
                    _buildTextField(hint: 'Documento de Identidad'),
                    const SizedBox(height: Constantes.separacion),
                    _buildTextField(hint: 'País'),
                    const SizedBox(height: Constantes.separacion),
                    _buildTextField(hint: 'Departamento'),
                    const SizedBox(height: Constantes.separacion),
                    _buildTextField(hint: 'Ciudad'),
                    const SizedBox(height: Constantes.separacion),
                    _buildTextField(hint: 'Fecha de nacimiento'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Constantes.separacion * 2),
            _buildContinueButton(context),
            const SizedBox(height: Constantes.separacion * 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, bool isPassword = false}) {
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
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
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

  Widget _buildContinueButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50),
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          if (widget.currentStep < 2) {
            widget.onStepChanged?.call(widget.currentStep + 1);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Tema.negro,
          foregroundColor: Tema.blanco,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Text(
          'Continuar',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Tema.blanco,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
