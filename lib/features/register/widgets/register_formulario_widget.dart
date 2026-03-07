import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class RegisterFormularioWidget extends ConsumerStatefulWidget {
  const RegisterFormularioWidget({super.key});

  @override
  ConsumerState<RegisterFormularioWidget> createState() =>
      _RegisterFormularioWidgetState();
}

class _RegisterFormularioWidgetState
    extends ConsumerState<RegisterFormularioWidget> {
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
      _usuarioFocusNode.unfocus();
      _passwordFocusNode.unfocus();
      final dispositivoState = ref.read(dispositivoProvider);
      final plataforma = dispositivoState.plataforma;
      ref
          .read(authProvider.notifier)
          .login(_usuarioController.text, _passwordController.text, plataforma);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final responsive = Responsive(context);

    return ZoomIn(
      duration: const Duration(milliseconds: 1000),
      child: ClipPath(
        clipper: _TopCurveClipper(),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Tema.primaryColor, Tema.primaryColor],
            ),
          ),
          child: Padding(
            padding: responsive.formPadding,
            child: Form(
              key: _formLoginKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  responsive.spacingBox,
                  _buildTituloSection(context),
                  responsive.spacingBox,
                  _buildFormUsuarioSection(context),
                  responsive.spacingBox,
                  _buildFormPasswordSection(context),
                  responsive.spacingBox,
                  _buildFormOlividarPasswordSection(context),
                  responsive.spacingBox,
                  _buildFormButtonSection(context, authState),
                  responsive.spacingBox,
                  _buildCreateAccountSection(context),
                  responsive.spacingBox,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTituloSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Crear cuenta',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Tema.blanco,
              fontStyle: FontStyle.italic,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Completar tus datos',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Tema.blanco,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('✌️', style: TextStyle(fontSize: 28)),
            ],
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
          // Aquí puedes agregar la lógica para recuperar la contraseña
        },
        child: Text(
          'Olvide mi contraseña',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
            ).textTheme.bodyMedium!.copyWith(color: Tema.blanco),
          ),
          GestureDetector(
            onTap: () {
              // Aquí puedes agregar la lógica para crear una cuenta
              //Navigator.pushNamed(context, '/register');
              context.go('/register');
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

// Clipper personalizado para la curva superior
class _TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Valores responsive basados en el tamaño del contenedor
    final curveStartHeight = size.height * 0.20; // 15% de la altura
    final curveDepth = size.height * -0.1; // Profundidad de la curva

    // Comenzar desde la parte inferior izquierda
    path.moveTo(0, size.height);

    // Línea hasta el punto de inicio de la curva (izquierda)
    path.lineTo(0, curveStartHeight);

    // Curva superior más pronunciada (arco cóncavo)
    path.quadraticBezierTo(
      size.width / 2, // Punto de control X (centro)
      curveDepth, // Punto de control Y (responsive)
      size.width, // Punto final X
      curveStartHeight, // Punto final Y
    );

    // Línea hasta la parte inferior derecha
    path.lineTo(size.width, size.height);

    // Cerrar el path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
