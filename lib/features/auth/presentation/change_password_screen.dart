import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    _passwordTemporalController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final n in otpFocusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _handleChangePassword() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final code = _fullCode;
      if (_formKey.currentState!.validate()) {
        if (_newPasswordController.text != _confirmPasswordController.text) {
          SnackbarUtil.snackbarNotificationPush(
            context,
            message: 'Las contraseñas no coinciden',
          );
          return;
        }
        if (code.length < 6) {
          SnackbarUtil.snackbarNotificationPush(
            context,
            message: 'Por favor ingresa el código OTP completo',
          );
          return;
        }
        ref
            .read(forgotProvider.notifier)
            .setPasswordTemporal(_passwordTemporalController.text);
        ref
            .read(forgotProvider.notifier)
            .setPasswordNueva(_newPasswordController.text);
        ref.read(forgotProvider.notifier).setCodigoOtp(code);
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
          SnackbarUtil.snackbarError(context, message: e.toString());
        } finally {
          ref.read(forgotProvider.notifier).resetearEstado();
        }
      }
    });
  }

  void _handleSendCode() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_formKey.currentState!.validate()) {
        try {
          ref
              .read(forgotProvider.notifier)
              .setLoading(isLoading: true, mensaje: 'Enviando código...');

          ref.invalidate(solicitoCambioClaveProvider);
          final response = await ref.read(solicitoCambioClaveProvider.future);

          if (!mounted) return;
          SnackbarUtil.snackbarNotificationPush(
            context,
            message: response.toString(),
          );
        } catch (e) {
          if (!mounted) return;
          SnackbarUtil.snackbarError(context, message: e.toString());
        } finally {
          ref.read(forgotProvider.notifier).setLoading(isLoading: false);
        }
      }
    });
  }

  String get _fullCode {
    return otpControllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Tema.blanco,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(bottom: false, child: _buildLogoSection(context)),
              _buildVioletSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection(BuildContext context) {
    return ZoomIn(
      duration: Constantes.standardAnimation,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 100),
          child: const IconoYataWidget(),
        ),
      ),
    );
  }

  Widget _buildVioletSection(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height * 0.75,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipPath(
            clipper: ConvexCurveClipper(
              screenHeight: screenSize.height,
              screenWidth: screenSize.width,
            ),
            child: Container(width: double.infinity, color: Tema.primaryColor),
          ),
          Positioned(
            top: -50,
            left: 24,
            right: 24,
            child: Column(
              children: [
                _buildChangePasswordCard(context),
                const SizedBox(height: 24),
                _buildRobotSection(context),
              ],
            ),
          ),
          _buildLoadingIndicator(context),
        ],
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

  Widget _buildChangePasswordCard(BuildContext context) {
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Tema.negro),
                    onPressed: () => Navigator.of(context).pop(),
                    splashRadius: 24,
                    tooltip: 'Volver',
                  ),
                ),
                Text(
                  'Cambiar Contraseña',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Tema.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: Constantes.separacionFormulario),
                Text(
                  'Ingresa tu contraseña actual (temporal), la nueva contraseña y el código OTP para confirmar el cambio.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Tema.negro,
                    height: 1.4,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: Constantes.separacionFormulario),
                _buildPasswordField(
                  context,
                  label: 'Contraseña actual (temporal)',
                  controller: _passwordTemporalController,
                  obscureText: ref.watch(obscureCurrentPasswordProvider),
                  onToggleVisibility: () {
                    ref
                        .read(obscureCurrentPasswordProvider.notifier)
                        .state = !ref
                        .read(obscureCurrentPasswordProvider.notifier)
                        .state;
                  },
                ),
                const SizedBox(height: Constantes.separacionFormulario),
                _buildPasswordField(
                  context,
                  label: 'Nueva contraseña',
                  controller: _newPasswordController,
                  obscureText: ref.watch(obscureNewPasswordProvider),
                  onToggleVisibility: () {
                    ref.read(obscureNewPasswordProvider.notifier).state = !ref
                        .read(obscureNewPasswordProvider.notifier)
                        .state;
                  },
                ),
                const SizedBox(height: Constantes.separacionFormulario),
                _buildPasswordField(
                  context,
                  label: 'Confirmar contraseña',
                  controller: _confirmPasswordController,
                  obscureText: ref.watch(obscureConfirmPasswordProvider),
                  onToggleVisibility: () {
                    ref
                        .read(obscureConfirmPasswordProvider.notifier)
                        .state = !ref
                        .read(obscureConfirmPasswordProvider.notifier)
                        .state;
                  },
                ),
                const SizedBox(height: Constantes.separacionFormulario),
                _buildOtpSection(context),
                const SizedBox(height: Constantes.separacionFormulario),
                _buildButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRobotSection(BuildContext context) {
    return RobotSectionWidget();
  }

  Widget _buildPasswordField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Tema.negro,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: Tema.negro),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Tema.primaryColor, width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: onToggleVisibility,
            ),
            counterText: '',
          ),
          maxLength: 20,
          validator: (value) => value == null || value.isEmpty
              ? 'Este campo es obligatorio'
              : value.length < 8
              ? 'Contraseña minimo 8 caracteres'
              : null,
        ),
      ],
    );
  }

  Widget _buildOtpSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Código OTP',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Tema.negro,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 8.0;
            const totalSpacing = spacing * 5;
            final fieldWidth = (constraints.maxWidth - totalSpacing) / 6;
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(6, (index) {
                return Container(
                  width: fieldWidth,
                  height: 55,
                  margin: EdgeInsets.only(right: index < 5 ? spacing : 0),
                  child: TextField(
                    controller: otpControllers[index],
                    focusNode: otpFocusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Tema.blanco,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Tema.negro,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Tema.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      if (value.length == 1 && index < 5) {
                        otpFocusNodes[index + 1].requestFocus();
                      } else if (value.length == 1 && index == 5) {
                        FocusScope.of(context).unfocus();
                      }
                      if (value.isEmpty && index > 0) {
                        otpFocusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: ref.watch(authProvider).isLoading
                ? null
                : _handleSendCode,
            style: OutlinedButton.styleFrom(
              foregroundColor: Tema.primaryColor,
              side: const BorderSide(color: Tema.primaryColor, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: ref.watch(authProvider).isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Enviar código',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        ),
        const SizedBox(height: Constantes.separacion),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: ref.watch(authProvider).isLoading
                ? null
                : _handleChangePassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Tema.primaryColor,
              foregroundColor: Tema.blanco,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: ref.watch(authProvider).isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Tema.blanco,
                    ),
                  )
                : const Text(
                    'Cambiar contraseña',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        ),
      ],
    );
  }
}
