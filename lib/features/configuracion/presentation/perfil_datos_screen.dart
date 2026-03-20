import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      final response = await ref.read(obtenerPerfilProvider.future);

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
    } catch (e) {
      if (!mounted) return;
      SnackbarUtil.snackbarError(context, message: e.toString());
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

  void _handleGuardar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cambios guardados exitosamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titulo: 'Modificar datos del perfil'),
      backgroundColor: Tema.blanco,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: [_buildVioletSection(context)]),
            ),
          ),
          _buildLoadingIndicator(context),
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

  Widget _buildVioletSection(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: screenSize.height,
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
            top: 20,
            left: 10,
            right: 10,
            child: SizedBox(
              height: screenSize.height * 0.85,
              child: _buildFormCard(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return FadeInUp(
      duration: Constantes.standardAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Tema.blanco,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Tema.negro.withValues(alpha: 0.3),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(hint: 'Login', _loginController, _loginFocus),
                const SizedBox(height: Constantes.separacion),
                _buildTextField(
                  hint: 'Celular',
                  _celularController,
                  _celularFocus,
                  isCelular: true,
                ),
                const SizedBox(height: Constantes.separacion),
                _buildSexoField(context),
                const SizedBox(height: Constantes.separacion),
                _buildTipoPersonaField(context),
                const SizedBox(height: Constantes.separacion),
                _buildTipoDocumentoField(context),
                const SizedBox(height: Constantes.separacion),
                _buildTextField(
                  hint: 'Número de documento',
                  _numeroDocumentoController,
                  _numeroDocumentoFocus,
                  isDNI:
                      ref.watch(
                        registerProvider.select((state) => state.tipoDocumento),
                      ) ==
                      1,
                ),
                const SizedBox(height: Constantes.separacion),
                _buildTextField(
                  hint: 'Apellido paterno',
                  _primerApellidoController,
                  _primerApellidoFocus,
                ),
                const SizedBox(height: Constantes.separacion),
                _buildTextField(
                  hint: 'Apellido materno',
                  _segundoApellidoController,
                  _segundoApellidoFocus,
                ),
                const SizedBox(height: Constantes.separacion),
                _buildTextField(
                  hint: 'Nombres',
                  _nombresController,
                  _nombresFocus,
                ),
                const SizedBox(height: Constantes.separacion),
                _buildFechaNacimientoField(context),
                const SizedBox(height: Constantes.separacion),
                _buildTextField(
                  hint: 'Correo',
                  _correoController,
                  _correoFocus,
                  isCorreo: true,
                ),
                const SizedBox(height: Constantes.separacion),
                _buildGuardarButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController? controller,
    FocusNode? focusNode, {
    required String hint,
    bool isPassword = false,
    bool isDNI = false,
    bool isCelular = false,
    bool isCorreo = false,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      cursorColor: Tema.primaryColor,
      style: const TextStyle(color: Colors.black87, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        labelStyle: TextStyle(color: Tema.primaryColor, fontSize: 14),
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        filled: true,
        fillColor: Tema.blanco,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Tema.primaryColor.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Tema.primaryColor, width: 2),
        ),
        suffixIcon: isPassword
            ? Icon(Icons.visibility_off, color: Tema.primaryColor)
            : null,
        errorStyle: Theme.of(
          context,
        ).textTheme.bodySmall!.copyWith(color: Tema.primaryColor),
        counterText: '',
      ),
      validator: (value) {
        if (isCorreo) {
          return ref.read(registerProvider.notifier).validarCorreo(value!);
        }
        return ref.read(registerProvider.notifier).validarCampo(value!, hint);
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
          : TextInputType.text,
      inputFormatters: isDNI
          ? [FilteringTextInputFormatter.digitsOnly]
          : isCelular
          ? [FilteringTextInputFormatter.digitsOnly]
          : [FilteringTextInputFormatter.singleLineFormatter],
    );
  }

  Widget _buildSexoField(BuildContext context) {
    final selectedSexo = ref.watch(
      perfilProvider.select((state) => state.sexo),
    );
    return DropdownButtonFormField<String>(
      initialValue: selectedSexo ? 'Masculino' : 'Femenino',
      decoration: InputDecoration(
        hintText: 'Sexo',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        filled: true,
        fillColor: Tema.blanco,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Tema.primaryColor.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Tema.primaryColor, width: 2),
        ),
      ),
      items: [
        DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
        DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
      ],
      onChanged: (value) {
        if (value != null) {
          ref.read(perfilProvider.notifier).setSexo(value == 'Masculino');
        }
      },
      validator: (value) {
        if (value == null) return 'Seleccione el sexo';
        return null;
      },
    );
  }

  Widget _buildTipoPersonaField(BuildContext context) {
    final selectedTipoPersona = ref.watch(
      perfilProvider.select((state) => state.idPersona),
    );
    return DropdownButtonFormField<int>(
      initialValue: selectedTipoPersona,
      decoration: InputDecoration(
        hintText: 'Tipo de persona',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        filled: true,
        fillColor: Tema.blanco,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Tema.primaryColor.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Tema.primaryColor, width: 2),
        ),
      ),
      items: const [
        DropdownMenuItem(value: 1, child: Text('Natural')),
        DropdownMenuItem(value: 2, child: Text('Jurídica')),
      ],
      onChanged: (value) {
        if (value != null) {
          ref.read(perfilProvider.notifier).setIdPersona(value);
        }
      },
      validator: (value) {
        if (value == null) return 'Seleccione el tipo de persona';
        return null;
      },
    );
  }

  Widget _buildTipoDocumentoField(BuildContext context) {
    final selectedTipoDocumento = ref.watch(
      perfilProvider.select((state) => state.idTipoDocumento),
    );
    return DropdownButtonFormField<int>(
      initialValue: selectedTipoDocumento,
      decoration: InputDecoration(
        hintText: 'Tipo de documento',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        filled: true,
        fillColor: Tema.blanco,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Tema.primaryColor.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Tema.primaryColor, width: 2),
        ),
      ),
      items: const [
        DropdownMenuItem(value: 1, child: Text('DNI')),
        DropdownMenuItem(value: 2, child: Text('CE')),
        DropdownMenuItem(value: 3, child: Text('Pasaporte')),
      ],
      onChanged: (value) {
        if (value != null) {
          ref.read(perfilProvider.notifier).setIdTipoDocumento(value);
        }
      },
      validator: (value) {
        if (value == null) return 'Seleccione el tipo de documento';
        return null;
      },
    );
  }

  Widget _buildFechaNacimientoField(BuildContext context) {
    final now = DateTime.now();
    final lastDate = DateTime(now.year - 18, now.month, now.day);

    return TextFormField(
      controller: _fechaNacimientoController,
      focusNode: _fechaNacimientoFocus,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Fecha de nacimiento',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        filled: true,
        fillColor: Tema.blanco,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Tema.primaryColor.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Tema.primaryColor, width: 2),
        ),
        suffixIcon: Icon(Icons.calendar_today, color: Tema.primaryColor),
        errorStyle: Theme.of(
          context,
        ).textTheme.bodySmall!.copyWith(color: Tema.primaryColor),
        counterText: '',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Seleccione la fecha de nacimiento';
        }
        final birthDate = DateTime.tryParse(value);
        if (birthDate == null) return 'Fecha inválida';
        final now = DateTime.now();
        final age =
            now.year -
            birthDate.year -
            ((now.month < birthDate.month ||
                    (now.month == birthDate.month && now.day < birthDate.day))
                ? 1
                : 0);
        if (age < 18) return 'Debe ser mayor de edad';
        return null;
      },
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: lastDate,
          firstDate: DateTime(now.year - 100, now.month, now.day),
          lastDate: lastDate,
        );

        if (pickedDate != null) {
          String formattedDate =
              '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
          _fechaNacimientoController.text = formattedDate;
        }
      },
    );
  }

  Widget _buildGuardarButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Constantes.botonHeightMedium,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Tema.negro, Tema.primaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              color: Tema.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Positioned.fill(
            child: ElevatedButton(
              onPressed: _handleGuardar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save_outlined, color: Tema.blanco, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Guardar cambios',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Tema.blanco,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
