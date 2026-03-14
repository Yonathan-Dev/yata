import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../core/app_exports.dart';

class RecuperarCardWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController loginController;
  final TextEditingController numeroDocumentoController;
  final TextEditingController emailController;
  final FocusNode loginFocusNode;
  final FocusNode numeroDocumentoFocusNode;
  final FocusNode emailFocusNode;

  final VoidCallback onBack;
  final VoidCallback onContinue;
  final Widget Function(BuildContext, {required VoidCallback onPressed})
  buildContinuarButton;

  const RecuperarCardWidget({
    super.key,
    required this.formKey,
    required this.loginController,
    required this.numeroDocumentoController,
    required this.emailController,
    required this.loginFocusNode,
    required this.numeroDocumentoFocusNode,
    required this.emailFocusNode,
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
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
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
                  'Ingresa tus datos para recibir una contraseña temporal',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Tema.negro,
                    height: 1.4,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: Constantes.separacionFormulario),
                TextFormField(
                  controller: loginController,
                  focusNode: loginFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Logín',
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Tema.gris,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    counterText: '',
                  ),
                  maxLength: 35,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu logín';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Ingresa un logín válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: Constantes.separacionFormulario),
                TextFormField(
                  controller: numeroDocumentoController,
                  focusNode: numeroDocumentoFocusNode,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Número documento',
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    prefixIcon: const Icon(
                      Icons.badge_outlined,
                      color: Tema.gris,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    counterText: '',
                  ),
                  maxLength: 15,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu número de documento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: Constantes.separacionFormulario),
                TextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Correo electrónico',
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Tema.gris,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    counterText: '',
                  ),
                  maxLength: 35,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu correo electrónico';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Ingresa un correo electrónico válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                buildContinuarButton(context, onPressed: onContinue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
