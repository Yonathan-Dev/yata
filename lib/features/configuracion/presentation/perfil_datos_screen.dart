import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart' hide AppBarWidget;
import '../../../shared/shared_exports.dart';

class PerfilDatosScreen extends ConsumerStatefulWidget {
  const PerfilDatosScreen({super.key});

  @override
  ConsumerState<PerfilDatosScreen> createState() => _PerfilDatosScreenState();
}

class _PerfilDatosScreenState extends ConsumerState<PerfilDatosScreen> {
  final _formKey = GlobalKey<FormState>();

  final _loginController = TextEditingController();
  final _loginFocus = FocusNode();
  final _celularController = TextEditingController();
  final _celularFocus = FocusNode();
  final _numeroDocumentoController = TextEditingController();
  final _numeroDocumentoFocus = FocusNode();
  final _primerApellidoController = TextEditingController();
  final _primerApellidoFocus = FocusNode();
  final _segundoApellidoController = TextEditingController();
  final _segundoApellidoFocus = FocusNode();
  final _nombresController = TextEditingController();
  final _nombresFocus = FocusNode();
  final _fechaNacimientoController = TextEditingController();
  final _fechaNacimientoFocus = FocusNode();
  final _correoController = TextEditingController();
  final _correoFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    Future.microtask(() => _loadPerfilData());
  }

  Future<void> _loadPerfilData() async {
    try {
      ref.read(perfilProvider.notifier).setIsLoading(true);
      ref.read(perfilProvider.notifier).setMensaje('Cargando datos...');
      ref.invalidate(obtenerPerfilProvider);
      final response = await ref.read(obtenerPerfilProvider.future);

      ref.read(perfilProvider.notifier).setLogin(response.login);
      ref.read(perfilProvider.notifier).setCelular(response.celular);
      ref
          .read(perfilProvider.notifier)
          .setNumeroDocumento(response.numeroDocumento);
      ref
          .read(perfilProvider.notifier)
          .setPrimerApellido(response.primerApellido);
      ref
          .read(perfilProvider.notifier)
          .setSegundoApellido(response.segundoApellido);
      ref.read(perfilProvider.notifier).setNombres(response.nombres);
      ref
          .read(perfilProvider.notifier)
          .setFechaNacimiento(response.fechaNacimiento);
      ref.read(perfilProvider.notifier).setCorreo(response.correo);

      _loginController.text = response.login;
      _celularController.text = response.celular;
      ref.read(perfilProvider.notifier).setSexo(response.sexo);
      ref.read(perfilProvider.notifier).setIdPersona(response.idPersona);
      ref
          .read(perfilProvider.notifier)
          .setIdTipoDocumento(response.idTipoDocumento);
      _numeroDocumentoController.text = response.numeroDocumento;
      _primerApellidoController.text = response.primerApellido;
      _segundoApellidoController.text = response.segundoApellido;
      _nombresController.text = response.nombres;
      _fechaNacimientoController.text = response.fechaNacimiento;
      _correoController.text = response.correo;
    } catch (error) {
      if (!mounted) return;
      SnackbarUtil.snackbarError(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      ref.read(perfilProvider.notifier).setIsLoading(false);
      ref.read(perfilProvider.notifier).setMensaje('');
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _loginFocus.dispose();
    _celularController.dispose();
    _celularFocus.dispose();
    _numeroDocumentoController.dispose();
    _numeroDocumentoFocus.dispose();
    _primerApellidoController.dispose();
    _primerApellidoFocus.dispose();
    _segundoApellidoController.dispose();
    _segundoApellidoFocus.dispose();
    _nombresController.dispose();
    _nombresFocus.dispose();
    _fechaNacimientoController.dispose();
    _fechaNacimientoFocus.dispose();
    _correoController.dispose();
    _correoFocus.dispose();
    super.dispose();
  }

  Future<void> _handleGuardar() async {
    if (_formKey.currentState!.validate()) {
      ref.read(perfilProvider.notifier).setIsLoading(true);
      ref.read(perfilProvider.notifier).setMensaje('Guardando cambios...');
      ref
          .read(perfilProvider.notifier)
          .capturarDatosPerfil(
            idUsuario: ref.watch(perfilProvider.select((s) => s.idUsuario)),
            idPersona: ref.watch(perfilProvider.select((s) => s.idPersona)),
            login: _loginController.text.trim(),
            celular: _celularController.text.trim(),
            sexo: ref.watch(perfilProvider.select((s) => s.sexo)),
            genero: ref.watch(perfilProvider.select((s) => s.genero)),
            tienePinConfigurado: ref.watch(
              perfilProvider.select((s) => s.tienePinConfigurado),
            ),
            idTipoDocumento: ref.watch(
              perfilProvider.select((s) => s.idTipoDocumento),
            ),
            numeroDocumento: _numeroDocumentoController.text.trim(),
            primerApellido: _primerApellidoController.text.trim(),
            segundoApellido: _segundoApellidoController.text.trim(),
            nombres: _nombresController.text.trim(),
            fechaNacimiento: _fechaNacimientoController.text.trim(),
            correo: _correoController.text.trim(),
          );
      try {
        ref.invalidate(modificarPerfilProvider);
        final response = await ref.read(modificarPerfilProvider.future);
        if (!mounted) return;
        SnackbarUtil.snackbarNotificationPush(
          context,
          message: response.toString(),
        );
        context.go('/home');
      } catch (error) {
        if (!mounted) return;
        SnackbarUtil.snackbarError(
          context,
          message: error.toString().replaceAll('Exception: ', ''),
        );
      } finally {
        ref.read(perfilProvider.notifier).setIsLoading(false);
        ref.read(perfilProvider.notifier).setMensaje('');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(inactivityProvider);
    return InactivityListener(
      child: Scaffold(
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
      ),
    );
  }

  // ── Background ────────────────────────────────────────────────

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
          SizedBox(height: screenSize.height * 0.025),

          // Icono hero
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
                Icons.manage_accounts_outlined,
                color: Tema.blanco,
                size: 32,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Título y subtítulo
          FadeInDown(
            duration: const Duration(milliseconds: 550),
            delay: const Duration(milliseconds: 80),
            child: Column(
              children: [
                Text(
                  'Datos del perfil',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Tema.blanco,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Revisa y actualiza tu información personal',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Tema.blanco,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenSize.height * 0.04),

          // Card del formulario
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            delay: const Duration(milliseconds: 150),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
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
                  _buildTextField(
                    label: 'Login / Usuario',
                    hint: 'Tu usuario o correo',
                    controller: _loginController,
                    focusNode: _loginFocus,
                    focusKey: 'login',
                    icon: Icons.alternate_email_rounded,
                    isCorreo: true,
                  ),
                  const SizedBox(height: Constantes.separacion),
                  _buildTextField(
                    label: 'Celular',
                    hint: '9XXXXXXXX',
                    controller: _celularController,
                    focusNode: _celularFocus,
                    focusKey: 'celular',
                    icon: Icons.phone_outlined,
                    isCelular: true,
                  ),
                  const SizedBox(height: 20),
                  _buildDivider(),
                  const SizedBox(height: 20),
                  _buildDropdownField<String>(
                    label: 'Sexo',
                    icon: Icons.wc_outlined,
                    value: ref.watch(perfilProvider.select((s) => s.sexo))
                        ? 'Masculino'
                        : 'Femenino',
                    items: const [
                      DropdownMenuItem(
                        value: 'Masculino',
                        child: Text('Masculino'),
                      ),
                      DropdownMenuItem(
                        value: 'Femenino',
                        child: Text('Femenino'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(perfilProvider.notifier)
                            .setSexo(value == 'Masculino');
                      }
                    },
                    validator: (v) => v == null ? 'Seleccione el sexo' : null,
                  ),
                  const SizedBox(height: Constantes.separacion),

                  _buildDropdownField<int>(
                    label: 'Tipo de persona',
                    icon: Icons.person_pin_outlined,
                    value: ref.watch(perfilProvider.select((s) => s.idPersona)),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Natural')),
                      DropdownMenuItem(value: 2, child: Text('Jurídica')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(perfilProvider.notifier).setIdPersona(value);
                      }
                    },
                    validator: (v) =>
                        v == null ? 'Seleccione el tipo de persona' : null,
                  ),
                  const SizedBox(height: Constantes.separacion),

                  _buildDropdownField<int>(
                    label: 'Tipo de documento',
                    icon: Icons.article_outlined,
                    value: ref.watch(
                      perfilProvider.select((s) => s.idTipoDocumento),
                    ),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('DNI')),
                      DropdownMenuItem(value: 2, child: Text('CE')),
                      DropdownMenuItem(value: 3, child: Text('Pasaporte')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(perfilProvider.notifier)
                            .setIdTipoDocumento(value);
                      }
                    },
                    validator: (v) =>
                        v == null ? 'Seleccione el tipo de documento' : null,
                  ),
                  const SizedBox(height: Constantes.separacion),

                  _buildTextField(
                    label: 'Número de documento',
                    hint:
                        ref.watch(
                              perfilProvider.select((s) => s.idTipoDocumento),
                            ) ==
                            1
                        ? '12345678'
                        : 'Número de documento',
                    controller: _numeroDocumentoController,
                    focusNode: _numeroDocumentoFocus,
                    focusKey: 'documento',
                    icon: Icons.numbers_rounded,
                    isDNI:
                        ref.watch(
                          perfilProvider.select((s) => s.idTipoDocumento),
                        ) ==
                        1,
                  ),

                  const SizedBox(height: 20),
                  _buildDivider(),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Apellido paterno',
                    hint: 'Tu primer apellido',
                    controller: _primerApellidoController,
                    focusNode: _primerApellidoFocus,
                    focusKey: 'apellidoP',
                    icon: Icons.text_fields_rounded,
                  ),
                  const SizedBox(height: Constantes.separacion),
                  _buildTextField(
                    label: 'Apellido materno',
                    hint: 'Tu segundo apellido',
                    controller: _segundoApellidoController,
                    focusNode: _segundoApellidoFocus,
                    focusKey: 'apellidoM',
                    icon: Icons.text_fields_rounded,
                  ),
                  const SizedBox(height: Constantes.separacion),
                  _buildTextField(
                    label: 'Nombres',
                    hint: 'Tus nombres completos',
                    controller: _nombresController,
                    focusNode: _nombresFocus,
                    focusKey: 'nombres',
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: Constantes.separacion),
                  _buildFechaNacimientoField(context),

                  const SizedBox(height: 20),
                  _buildDivider(),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Correo electrónico',
                    hint: 'ejemplo@correo.com',
                    controller: _correoController,
                    focusNode: _correoFocus,
                    focusKey: 'correo',
                    icon: Icons.email_outlined,
                    isCorreo: true,
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
                      Expanded(
                        child: Text(
                          'El correo se usará para notificaciones y recuperación',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.grey,
                            letterSpacing: 0.1,
                          ),
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

  InputDecoration _buildInputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    required bool isFocused,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Icon(
        icon,
        color: isFocused ? Tema.primaryColor : Colors.grey[400],
        size: 20,
      ),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: isFocused
          ? Tema.primaryColor.withValues(alpha: 0.04)
          : Colors.grey[50],
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
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      errorStyle: Theme.of(
        context,
      ).textTheme.bodySmall!.copyWith(color: Colors.redAccent),
      counterText: '',
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String focusKey,
    required IconData icon,
    bool isDNI = false,
    bool isCelular = false,
    bool isCorreo = false,
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
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              letterSpacing: 0.2,
            ),
            decoration: InputDecoration(counterText: ''),
            validator: (value) {
              if (isCorreo) {
                return ref
                    .read(registerProvider.notifier)
                    .validarCorreo(value!);
              }
              return ref
                  .read(registerProvider.notifier)
                  .validarCampo(value!, label);
            },
            maxLength: isDNI
                ? 8
                : isCelular
                ? 9
                : 25,
            keyboardType: isDNI
                ? TextInputType.number
                : isCelular
                ? TextInputType.phone
                : isCorreo
                ? TextInputType.emailAddress
                : TextInputType.text,
            inputFormatters: isDNI || isCelular
                ? [FilteringTextInputFormatter.digitsOnly]
                : isCorreo
                ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))]
                : [FilteringTextInputFormatter.singleLineFormatter],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required FormFieldValidator<T> validator,
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
        DropdownButtonFormField<T>(
          initialValue: value,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
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
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
            errorStyle: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Colors.redAccent),
          ),
          dropdownColor: Tema.blanco,
          borderRadius: BorderRadius.circular(14),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey[400],
          ),
          style: const TextStyle(color: Colors.black87, fontSize: 15),
          items: items,
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildFechaNacimientoField(BuildContext context) {
    final now = DateTime.now();
    final lastDate = DateTime(now.year - 18, now.month, now.day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha de nacimiento',
          style: TextStyle(
            fontSize: 11.5,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _fechaNacimientoController,
          focusNode: _fechaNacimientoFocus,
          readOnly: true,
          style: const TextStyle(color: Colors.black87, fontSize: 15),
          decoration: _buildInputDecoration(
            label: 'Fecha de nacimiento',
            hint: 'AAAA-MM-DD',
            icon: Icons.calendar_month_outlined,
            isFocused: false,
            suffixIcon: Icon(
              Icons.edit_calendar_outlined,
              color: Tema.primaryColor.withValues(alpha: 0.7),
              size: 20,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Seleccione la fecha de nacimiento';
            }
            final birthDate = DateTime.tryParse(value);
            if (birthDate == null) return 'Fecha inválida';
            final age =
                now.year -
                birthDate.year -
                ((now.month < birthDate.month ||
                        (now.month == birthDate.month &&
                            now.day < birthDate.day))
                    ? 1
                    : 0);
            if (age < 18) return 'Debe ser mayor de edad';
            return null;
          },
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: lastDate,
              firstDate: DateTime(now.year - 100, now.month, now.day),
              lastDate: lastDate,
              builder: (context, child) => Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Tema.primaryColor,
                    onPrimary: Tema.blanco,
                    surface: Tema.blanco,
                  ),
                  dialogTheme: DialogThemeData(backgroundColor: Tema.blanco),
                ),
                child: child!,
              ),
            );
            if (pickedDate != null) {
              _fechaNacimientoController.text =
                  '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
            }
          },
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
    final state = ref.watch(perfilProvider);
    if (state.isLoading) return LoadingWidget(mensaje: state.mensaje);
    return const SizedBox.shrink();
  }
}
