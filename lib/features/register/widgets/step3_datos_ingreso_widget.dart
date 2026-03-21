import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class Step3DatosIngresoWidget extends ConsumerStatefulWidget {
  const Step3DatosIngresoWidget({super.key});

  @override
  ConsumerState<Step3DatosIngresoWidget> createState() =>
      _Step3DatosIngresoWidgetState();
}

class _Step3DatosIngresoWidgetState
    extends ConsumerState<Step3DatosIngresoWidget> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _confirmaCorreoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _confirmaContrasenaController = TextEditingController();
  final _correoFocusNode = FocusNode();
  final _confirmaCorreoFocusNode = FocusNode();
  final _contrasenaFocusNode = FocusNode();
  final _confirmaContrasenaFocusNode = FocusNode();

  @override
  void dispose() {
    _correoController.dispose();
    _confirmaCorreoController.dispose();
    _contrasenaController.dispose();
    _confirmaContrasenaController.dispose();
    _correoFocusNode.dispose();
    _confirmaCorreoFocusNode.dispose();
    _contrasenaFocusNode.dispose();
    _confirmaContrasenaFocusNode.dispose();
    super.dispose();
  }

  Future<String?> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      ref.read(registerProvider.notifier).setIsLoading(true);
      ref.read(registerProvider.notifier).setMensaje('Enviando OTP...');
      _correoFocusNode.unfocus();
      _confirmaCorreoFocusNode.unfocus();
      _contrasenaFocusNode.unfocus();
      _confirmaContrasenaFocusNode.unfocus();
      ref
          .read(registerProvider.notifier)
          .setCorreo(_correoController.text.trim());
      ref
          .read(registerProvider.notifier)
          .setConfirmaCorreo(_confirmaCorreoController.text.trim());
      ref
          .read(registerProvider.notifier)
          .setContrasena(_contrasenaController.text.trim());
      ref
          .read(registerProvider.notifier)
          .setConfirmaContrasena(_confirmaContrasenaController.text.trim());

      if (ref.read(registerProvider.notifier).validarCorreos() != null) {
        ref.read(registerProvider.notifier).setIsLoading(false);
        SnackbarUtil.snackbarNotificationPush(
          context,
          message: ref.read(registerProvider.notifier).validarCorreos()!,
        );
        return null;
      }
      if (ref.read(registerProvider.notifier).validarContrasenas() != null) {
        ref.read(registerProvider.notifier).setIsLoading(false);
        SnackbarUtil.snackbarNotificationPush(
          context,
          message: ref.read(registerProvider.notifier).validarContrasenas()!,
        );
        return null;
      }

      try {
        final response = await ref.read(enviarOTPProvider.future);
        if (!mounted) return null;

        SnackbarUtil.snackbarNotificationPush(context, message: response);
        context.push('/verify-code');
      } catch (e) {
        if (!mounted) return null;
        SnackbarUtil.snackbarError(context, message: e.toString());
      } finally {
        ref.read(registerProvider.notifier).setIsLoading(false);
        ref.read(registerProvider.notifier).setMensaje('');
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Constantes.standardAnimation,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Tema.blanco, width: 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      _buildTextFieldWhiteBorder(
                        _correoController,
                        _correoFocusNode,
                        hint: 'Correo electrónico:',
                        isEmail: true,
                      ),
                      const SizedBox(height: Constantes.separacion),
                      _buildTextFieldWhiteBorder(
                        _confirmaCorreoController,
                        _confirmaCorreoFocusNode,
                        hint: 'Confirma tu correo electrónico:',
                        isEmail: true,
                      ),
                      const SizedBox(height: Constantes.separacion),
                      _buildTextFieldWhiteBorder(
                        _contrasenaController,
                        _contrasenaFocusNode,
                        hint: 'Crea tu contraseña',
                        isPassword: true,
                      ),
                      const SizedBox(height: Constantes.separacion),
                      _buildTextFieldWhiteBorder(
                        _confirmaContrasenaController,
                        _confirmaContrasenaFocusNode,
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
                      value: ref.watch(registerProvider).terminos,
                      onChanged: (value) {
                        ref
                            .read(registerProvider.notifier)
                            .setTerminos(value ?? false);
                      },
                      text: 'Acepta términos y condiciones',
                    ),
                    const SizedBox(height: 12),
                    _buildCheckboxItem(
                      value: ref.watch(registerProvider).politicaDatos,
                      onChanged: (value) {
                        ref
                            .read(registerProvider.notifier)
                            .setPoliticaDatos(value ?? false);
                      },
                      text: 'Aceptar política de uso de datos',
                    ),
                    const SizedBox(height: 12),
                    _buildCheckboxItem(
                      value: ref.watch(registerProvider).promociones,
                      onChanged: (value) {
                        ref
                            .read(registerProvider.notifier)
                            .setPromociones(value ?? false);
                      },
                      text: 'Recibir por correo electrónico promociones',
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
                  onPressed: (ref.watch(registerProvider).terminos)
                      ? _handleSubmit
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
              TextButton(
                onPressed: () {
                  context.go('/auth');
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
      ),
    );
  }

  Widget _buildTextFieldWhiteBorder(
    TextEditingController controller,
    FocusNode? focusNode, {
    required String hint,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Tema.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: isPassword,
        cursorColor: Tema.primaryColor,
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
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Tema.primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Tema.blanco,
          errorStyle: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(color: Tema.blanco),
        ),
        validator: isEmail
            ? (value) {
                return ref
                    .read(registerProvider.notifier)
                    .validarCorreo(value ?? '');
              }
            : isPassword
            ? (value) {
                return ref
                    .read(registerProvider.notifier)
                    .validarContrasena(value ?? '');
              }
            : null,
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
