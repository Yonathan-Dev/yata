import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_exports.dart' hide AppBarWidget;
import '../../../shared/shared_exports.dart';

class CambiarContrasenaScreen extends ConsumerStatefulWidget {
  const CambiarContrasenaScreen({super.key});

  @override
  ConsumerState<CambiarContrasenaScreen> createState() =>
      _CambiarContrasenaScreenState();
}

class _CambiarContrasenaScreenState
    extends ConsumerState<CambiarContrasenaScreen> {
  final _formKey = GlobalKey<FormState>();

  final _contrasenaActualController = TextEditingController();
  final _contrasenaActualFocus = FocusNode();
  final _nuevaContrasenaController = TextEditingController();
  final _nuevaContrasenaFocus = FocusNode();
  final _confirmarContrasenaController = TextEditingController();
  final _confirmarContrasenaFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _contrasenaActualController.dispose();
    _contrasenaActualFocus.dispose();
    _nuevaContrasenaController.dispose();
    _nuevaContrasenaFocus.dispose();
    _confirmarContrasenaController.dispose();
    _confirmarContrasenaFocus.dispose();
    super.dispose();
  }

  Future<void> _handleGuardar() async {
    if (_formKey.currentState!.validate()) {
      if (_nuevaContrasenaController.text.trim() !=
          _confirmarContrasenaController.text.trim()) {
        SnackbarUtil.snackbarNotificationPush(
          context,
          message: 'Las nuevas contraseñas no coinciden',
        );
        return;
      }

      try {
        ref
            .read(cambiarContrasenaProvider.notifier)
            .setContrasenaActual(_contrasenaActualController.text.trim());
        ref
            .read(cambiarContrasenaProvider.notifier)
            .setNuevaContrasena(_nuevaContrasenaController.text.trim());
        ref.read(cambiarContrasenaProvider.notifier).setIsLoading(true);
        ref
            .read(cambiarContrasenaProvider.notifier)
            .setMensaje('Actualizando contraseña...');
        ref.invalidate(solicitarCambioContrasenaProvider);
        await ref.read(solicitarCambioContrasenaProvider.future);
        if (!mounted) return;
        SnackbarUtil.snackbarNotificationPush(
          context,
          message: 'Contraseña actualizada exitosamente',
        );
        await ref.read(cambiarContrasenaProvider.notifier).logout();
      } catch (e) {
        if (!mounted) return;
        SnackbarUtil.snackbarError(context, message: e.toString());
      } finally {
        ref.read(cambiarContrasenaProvider.notifier).setIsLoading(false);
        ref.read(cambiarContrasenaProvider.notifier).setMensaje('');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tema.blanco,
      body: Stack(
        children: [
          _buildBackground(context),
          SafeArea(
            child: Column(
              children: [
                _buildCustomAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(key: _formKey, child: _buildContent(context)),
                  ),
                ),
              ],
            ),
          ),
          _buildLoadingIndicator(context),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        ClipPath(
          clipper: ConvexCurveClipper(
            screenHeight: screenSize.height,
            screenWidth: screenSize.width,
          ),
          child: Container(width: double.infinity, color: Tema.primaryColor),
        ),
        Positioned(
          top: -40,
          right: -40,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Tema.blanco.withValues(alpha: 0.06),
            ),
          ),
        ),
        Positioned(
          top: 60,
          left: -30,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Tema.blanco.withValues(alpha: 0.05),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Tema.primaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: screenSize.height * 0.03),
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Tema.blanco.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Tema.blanco.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                color: Tema.blanco,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeInDown(
            duration: const Duration(milliseconds: 550),
            delay: const Duration(milliseconds: 80),
            child: Column(
              children: [
                Text(
                  'Actualiza tu contraseña',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Tema.blanco,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ingresa tu contraseña actual y define\nuna nueva para continuar',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Tema.blanco,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenSize.height * 0.045),
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            delay: const Duration(milliseconds: 150),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Tema.blanco,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Tema.primaryColor.withValues(alpha: 0.15),
                    blurRadius: 32,
                    spreadRadius: 0,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: Tema.negro.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildTextField(
                    label: 'Contraseña actual',
                    hint: '••••••••',
                    controller: _contrasenaActualController,
                    focusNode: _contrasenaActualFocus,
                    focusKey: 'actual',
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    showPassword: ref.watch(showActualPasswordProvider),
                    onTogglePassword: () =>
                        ref
                            .read(showActualPasswordProvider.notifier)
                            .state = !ref
                            .read(showActualPasswordProvider.notifier)
                            .state,
                  ),
                  const SizedBox(height: Constantes.separacion),
                  _buildTextField(
                    label: 'Nueva contraseña',
                    hint: '••••••••',
                    controller: _nuevaContrasenaController,
                    focusNode: _nuevaContrasenaFocus,
                    focusKey: 'nueva',
                    icon: Icons.lock_open_rounded,
                    isPassword: true,
                    showPassword: ref.watch(showNuevaPasswordProvider),
                    onTogglePassword: () =>
                        ref.read(showNuevaPasswordProvider.notifier).state =
                            !ref.read(showNuevaPasswordProvider.notifier).state,
                  ),
                  const SizedBox(height: Constantes.separacion),
                  _buildTextField(
                    label: 'Confirmar nueva contraseña',
                    hint: '••••••••',
                    controller: _confirmarContrasenaController,
                    focusNode: _confirmarContrasenaFocus,
                    focusKey: 'confirmar',
                    icon: Icons.lock_person_outlined,
                    isPassword: true,
                    showPassword: ref.watch(showConfirmPasswordProvider),
                    onTogglePassword: () =>
                        ref
                            .read(showConfirmPasswordProvider.notifier)
                            .state = !ref
                            .read(showConfirmPasswordProvider.notifier)
                            .state,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 13,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Usa al menos 8 caracteres con letras y números',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey[400],
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildGuardarButton(context),
                ],
              ),
            ),
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String focusKey,
    required IconData icon,
    bool isPassword = false,
    bool showPassword = false,
    VoidCallback? onTogglePassword,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            cursorColor: Tema.primaryColor,
            obscureText: isPassword && !showPassword,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              letterSpacing: 0.2,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        showPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                      onPressed: onTogglePassword,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Tema.primaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Tema.primaryColor,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Tema.primaryColor,
                  width: 2,
                ),
              ),
              errorStyle: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: Tema.primaryColor),
              counterText: '',
            ),
            validator: (value) {
              return ref
                  .read(cambiarContrasenaProvider.notifier)
                  .validarCampo(value!, label);
            },
            maxLength: 50,
            keyboardType: isPassword
                ? TextInputType.visiblePassword
                : TextInputType.text,
            inputFormatters: isPassword
                ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))]
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildGuardarButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Constantes.botonHeightMedium,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Tema.primaryColor,
              Tema.primaryColor.withValues(alpha: 0.82),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Tema.primaryColor.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _handleGuardar,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Tema.blanco,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                'Guardar cambios',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Tema.blanco,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final state = ref.watch(cambiarContrasenaProvider);
    if (state.isLoading) {
      return LoadingWidget(mensaje: state.mensaje);
    }
    return const SizedBox.shrink();
  }
}
