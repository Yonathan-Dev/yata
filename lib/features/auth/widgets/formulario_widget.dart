import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class FormularioWidget extends ConsumerStatefulWidget {
  const FormularioWidget({super.key});

  @override
  ConsumerState<FormularioWidget> createState() => _FormularioWidgetState();
}

class _FormularioWidgetState extends ConsumerState<FormularioWidget> {
  final _formLoginKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usuarioFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    _usuarioFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formLoginKey.currentState!.validate()) {
      ref
          .read(registerProvider.notifier)
          .setCorreo(_usuarioController.text.trim());
      ref
          .read(registerProvider.notifier)
          .setContrasena(_passwordController.text.trim());

      ref
          .read(authProvider.notifier)
          .setLoading(isLoading: true, mensaje: 'Iniciando sesión...');
      ref
          .read(loginCorreoProvider.future)
          .then((response) async {
            if (response.requiereVerificacion) {
              if (!mounted) return;
              SnackbarUtil.snackbarInfo(
                context,
                message: response.mensajeVerificacion,
              );
              await secureStorage.write(
                key: 'verificationToken',
                value: response.verificationToken,
              );
              if (!mounted) return;
              context.push('/verification-otp');
              return;
            }

            await secureStorage.write(
              key: 'accessToken',
              value: response.accessToken,
            );
            await secureStorage.write(
              key: 'refreshToken',
              value: response.refreshToken,
            );
            await secureStorage.write(
              key: 'expiresAt',
              value: response.expiresAt.toIso8601String(),
            );
            await secureStorage.write(
              key: 'tokenType',
              value: response.tokenType,
            );

            if (!mounted) return;
            context.go('/pin');
          })
          .catchError((error) {
            if (!mounted) return;
            SnackbarUtil.snackbarError(context, message: error.toString());
          })
          .whenComplete(() {
            if (!mounted) return;
            _usuarioFocusNode.unfocus();
            _passwordFocusNode.unfocus();
            ref
                .read(authProvider.notifier)
                .setLoading(isLoading: false, mensaje: '');
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formLoginKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              _buildSaludoSection(context),
              const SizedBox(height: 32),
              _buildFormUsuarioSection(context),
              const SizedBox(height: Constantes.separacion),
              _buildFormPasswordSection(context),
              const SizedBox(height: Constantes.separacion / 2),
              _buildFormOlividarPasswordSection(context),
              const SizedBox(height: Constantes.separacion),
              _buildFormButtonSection(context, authState),
              const SizedBox(height: Constantes.separacion),
              _buildCreateAccountSection(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaludoSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            '¡Hola,',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Tema.blanco,
              fontSize: 35.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [Image.asset('assets/iconos/bienvenida.png', height: 36)],
          ),
        ],
      ),
    );
  }

  Widget _buildFormUsuarioSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Correo electrónico',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: Tema.blanco),
        ),
        const SizedBox(height: 8),
        TextFormField(
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: Tema.negro),
          controller: _usuarioController,
          focusNode: _usuarioFocusNode,
          decoration: InputDecoration(
            filled: true,
            fillColor: Tema.blanco,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Tema.blanco, width: 2),
            ),
            errorStyle: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Tema.blanco),
            counterText: '',
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            return ref
                .read(registerProvider.notifier)
                .validarCorreo(value ?? '');
          },
          maxLength: 35,
        ),
      ],
    );
  }

  Widget _buildFormPasswordSection(BuildContext context) {
    final verContrasenya = ref.watch(verContrasenyaProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contraseña',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: Tema.blanco),
        ),
        const SizedBox(height: 8),
        TextFormField(
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: Tema.negro),
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          obscureText: !verContrasenya,
          decoration: InputDecoration(
            filled: true,
            fillColor: Tema.blanco,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Tema.blanco, width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                verContrasenya ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                ref.read(verContrasenyaProvider.notifier).state =
                    !verContrasenya;
              },
            ),
            errorStyle: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Tema.blanco),
            counterText: '',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu contraseña';
            }
            if (value.length < 8) {
              return 'Mínimo 8 caracteres';
            }
            return null;
          },
          maxLength: 25,
        ),
      ],
    );
  }

  Widget _buildFormOlividarPasswordSection(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          context.push('/forgot-password');
        },
        child: Text(
          'Olvide mi contraseña',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Tema.blanco,
            decoration: TextDecoration.underline,
            decorationColor: Tema.blanco,
          ),
        ),
      ),
    );
  }

  Widget _buildFormButtonSection(BuildContext context, AuthState authState) {
    return SizedBox(
      width: double.infinity,
      height: Constantes.alturaFormulario,
      child: ElevatedButton(
        onPressed: authState.isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Tema.negro,
          foregroundColor: Tema.blanco,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: Tema.blanco, width: 1.0),
          textStyle: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
        ),
        child: const Text('Login'),
      ),
    );
  }

  Widget _buildCreateAccountSection(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            '¿Aún no tienes una cuenta? ',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: Tema.blanco),
          ),
          GestureDetector(
            onTap: () {
              context.push('/register');
            },
            child: Text(
              'Regístrate',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Tema.blanco,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: Tema.blanco,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
