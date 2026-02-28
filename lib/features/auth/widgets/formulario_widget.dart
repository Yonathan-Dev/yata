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
    ref.read(dispositivoProvider.notifier).obtenerInfoDispositivo();

    if (ref.read(recordarProvider.notifier).state == true) {
      Future.microtask(() {
        final prefsService = ref.read(preferencesServiceProvider);
        prefsService.getSavedUsername().then((savedUsername) {
          if (savedUsername != null) {
            _usuarioController.text = savedUsername;
          }
        });
        prefsService.getSavedPassword().then((savedPassword) {
          if (savedPassword != null) {
            _passwordController.text = savedPassword;
          }
        });
      });
    }
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
      context.go('/pin');
      /*_usuarioFocusNode.unfocus();
      _passwordFocusNode.unfocus();
      final dispositivoState = ref.read(dispositivoProvider);
      final plataforma = dispositivoState.plataforma;
      ref
          .read(authProvider.notifier)
          .login(_usuarioController.text, _passwordController.text, plataforma);*/
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
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu correo electrónico';
            }
            return null;
          },
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
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu contraseña';
            }
            if (value.length < 6) {
              return 'La contraseña debe tener al menos 6 caracteres';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFormOlividarPasswordSection(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          //context.go('/forgot-password');
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¿Aún no tienes una cuenta? ',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: Tema.blanco),
          ),
          GestureDetector(
            onTap: () {
              //context.go('/register');
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
