import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart' hide AppBarWidget;
import '../../../shared/shared_exports.dart';

class SolicitarOtpScreen extends ConsumerStatefulWidget {
  const SolicitarOtpScreen({super.key});

  @override
  ConsumerState<SolicitarOtpScreen> createState() => _SolicitarOtpScreenState();
}

class _SolicitarOtpScreenState extends ConsumerState<SolicitarOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _correoFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _correoController.dispose();
    _correoFocus.dispose();
    super.dispose();
  }

  Future<void> _handleEnviarCodigo() async {
    if (_formKey.currentState!.validate()) {
      context.push('/configuracion/verify-code');
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
            icon: Icon(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenSize.height * 0.03),
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: Center(
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
                child: Icon(
                  Icons.mark_email_unread_outlined,
                  color: Tema.blanco,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeInDown(
            duration: const Duration(milliseconds: 550),
            delay: const Duration(milliseconds: 80),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Solicitar código OTP',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Tema.blanco,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Te enviaremos un código de verificación\na tu correo electrónico',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Tema.blanco,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextFormField(
                      controller: _correoController,
                      focusNode: _correoFocus,
                      cursorColor: Tema.primaryColor,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        letterSpacing: 0.2,
                      ),
                      decoration: InputDecoration(
                        hintText: 'ejemplo@correo.com',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        prefixIcon: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.alternate_email_rounded,
                            color: Tema.primaryColor,
                            size: 20,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        filled: true,
                        fillColor: Tema.primaryColor.withValues(alpha: 0.04),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.grey[200]!,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Tema.primaryColor,
                            width: 2,
                          ),
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
                        errorStyle: Theme.of(context).textTheme.bodySmall!
                            .copyWith(color: Tema.primaryColor),
                        counterText: '',
                      ),
                      validator: (value) => ref
                          .read(registerProvider.notifier)
                          .validarCorreo(value!),
                      maxLength: 50,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
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
                        'Usa el correo asociado a tu cuenta',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildEnviarCodigoButton(context),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final state = ref.watch(perfilProvider);
    if (state.isLoading) {
      return LoadingWidget(mensaje: state.mensaje);
    }
    return const SizedBox.shrink();
  }

  Widget _buildEnviarCodigoButton(BuildContext context) {
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
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: _handleEnviarCodigo,
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
              Icon(Icons.send_rounded, color: Tema.blanco, size: 20),
              const SizedBox(width: 8),
              Text(
                'Enviar código',
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
}
