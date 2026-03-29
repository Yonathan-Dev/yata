import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordTemporalController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _passwordTemporalFocus = FocusNode();
  final _newPasswordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordTemporalController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _passwordTemporalFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_formKey.currentState!.validate()) {
        if (_newPasswordController.text != _confirmPasswordController.text) {
          SnackbarUtil.snackbarNotificationPush(
            context,
            message: 'Las contraseñas no coinciden',
          );
          return;
        }
        ref
            .read(forgotProvider.notifier)
            .setPasswordTemporal(_passwordTemporalController.text);
        ref
            .read(forgotProvider.notifier)
            .setPasswordNueva(_newPasswordController.text);
        ref
            .read(forgotProvider.notifier)
            .setLoading(isLoading: true, mensaje: 'Verificando...');

        final response = await ref.read(cambiarClaveProvider.future);
        try {
          if (!mounted) return;
          SnackbarUtil.snackbarNotificationPush(context, message: response);
          await secureStorage.write(key: 'passwordTemporary', value: 'false');
          await secureStorage.write(key: 'flagRegistrado', value: 'true');

          if (!mounted) return;
          context.go('/pin');
        } catch (e) {
          if (!mounted) return;
          SnackbarUtil.snackbarError(
            context,
            message: e.toString().replaceAll('Exception: ', ''),
          );
        } finally {
          ref.read(forgotProvider.notifier).resetearEstado();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tema.blanco,
      resizeToAvoidBottomInset: true,
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
                Icons.password_rounded,
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
                  'Cambiar contraseña',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Tema.blanco,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ingresa tu contraseña temporal y define\nuna nueva para continuar',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Tema.blanco.withValues(alpha: 0.75),
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
                  _buildPasswordField(
                    label: 'Contraseña temporal',
                    hint: '••••••••',
                    controller: _passwordTemporalController,
                    focusNode: _passwordTemporalFocus,
                    focusKey: 'temporal',
                    icon: Icons.lock_clock_outlined,
                    showPassword: ref.watch(obscureCurrentPasswordProvider),
                    onToggle: () =>
                        ref
                            .read(obscureCurrentPasswordProvider.notifier)
                            .state = !ref.watch(
                          obscureCurrentPasswordProvider,
                        ),
                  ),
                  const SizedBox(height: 20),
                  _buildDivider(),
                  const SizedBox(height: 10),
                  _buildPasswordField(
                    label: 'Nueva contraseña',
                    hint: '••••••••',
                    controller: _newPasswordController,
                    focusNode: _newPasswordFocus,
                    focusKey: 'nueva',
                    icon: Icons.lock_open_rounded,
                    showPassword: ref.watch(obscureNewPasswordProvider),
                    onToggle: () =>
                        ref.read(obscureNewPasswordProvider.notifier).state =
                            !ref.watch(obscureNewPasswordProvider),
                  ),
                  const SizedBox(height: Constantes.separacion),
                  _buildPasswordField(
                    label: 'Confirmar contraseña',
                    hint: '••••••••',
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    focusKey: 'confirmar',
                    icon: Icons.lock_person_outlined,
                    showPassword: ref.watch(obscureConfirmPasswordProvider),
                    onToggle: () =>
                        ref
                            .read(obscureConfirmPasswordProvider.notifier)
                            .state = !ref.watch(
                          obscureConfirmPasswordProvider,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 13,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Mínimo 8 caracteres con letras y números',
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

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[200], thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            Icons.more_horiz_rounded,
            size: 16,
            color: Colors.grey[300],
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[200], thickness: 1)),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String focusKey,
    required IconData icon,
    required bool showPassword,
    required VoidCallback onToggle,
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
            obscureText: !showPassword,
            cursorColor: Tema.primaryColor,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              letterSpacing: 0.2,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: Colors.grey[400],
                  size: 20,
                ),
                onPressed: onToggle,
              ),
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
            maxLength: 20,
            validator: (value) => value == null || value.isEmpty
                ? 'Este campo es obligatorio'
                : value.length < 8
                ? 'Contraseña mínimo 8 caracteres'
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildGuardarButton(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;
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
          onPressed: isLoading ? null : _handleChangePassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Tema.blanco,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Tema.blanco,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Cambiar contraseña',
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
    final forgotState = ref.watch(forgotProvider);
    if (forgotState.isLoading) {
      return const LoadingWidget(mensaje: 'Procesando...');
    }
    return const SizedBox.shrink();
  }
}
