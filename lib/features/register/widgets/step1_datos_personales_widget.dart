import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_exports.dart';

class Step1DatosPersonalesWidget extends ConsumerStatefulWidget {
  final int currentStep;
  final void Function(int)? onStepChanged;
  const Step1DatosPersonalesWidget({
    super.key,
    required this.currentStep,
    this.onStepChanged,
  });

  @override
  ConsumerState<Step1DatosPersonalesWidget> createState() =>
      _Step1DatosPersonalesWidgetState();
}

class _Step1DatosPersonalesWidgetState
    extends ConsumerState<Step1DatosPersonalesWidget> {
  final _formKey = GlobalKey<FormState>();
  final _numeroDocumentoController = TextEditingController();
  final _primerApellidoController = TextEditingController();
  final _segundoApellidoController = TextEditingController();
  final _nombresController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();
  final _celularController = TextEditingController();
  final _contactoController = TextEditingController();
  final _numeroDocumentoFocus = FocusNode();
  final _primerApellidoFocus = FocusNode();
  final _segundoApellidoFocus = FocusNode();
  final _nombresFocus = FocusNode();
  final _fechaNacimientoFocus = FocusNode();
  final _celularFocus = FocusNode();
  final _contactoFocus = FocusNode();
  int? _tipoPersona;
  int? _tipoDocumento;
  bool? _sexo;

  @override
  void dispose() {
    _numeroDocumentoController.dispose();
    _primerApellidoController.dispose();
    _segundoApellidoController.dispose();
    _nombresController.dispose();
    _fechaNacimientoController.dispose();
    _celularController.dispose();
    _contactoController.dispose();
    _numeroDocumentoFocus.dispose();
    _primerApellidoFocus.dispose();
    _segundoApellidoFocus.dispose();
    _nombresFocus.dispose();
    _fechaNacimientoFocus.dispose();
    _celularFocus.dispose();
    _contactoFocus.dispose();
    super.dispose();
  }

  _handleContinue(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      ref
          .read(registerProvider.notifier)
          .setNumeroDocumento(_numeroDocumentoController.text.trim());
      ref
          .read(registerProvider.notifier)
          .setPrimerApellido(_primerApellidoController.text.trim());
      ref
          .read(registerProvider.notifier)
          .setSegundoApellido(_segundoApellidoController.text.trim());
      ref
          .read(registerProvider.notifier)
          .setNombres(_nombresController.text.trim());
      ref
          .read(registerProvider.notifier)
          .setFechaNacimiento(_fechaNacimientoController.text.trim());
      ref
          .read(registerProvider.notifier)
          .setCelular(_celularController.text.trim());
      ref
          .read(registerProvider.notifier)
          .setContacto(_contactoController.text.trim());

      if (widget.currentStep < 2) {
        widget.onStepChanged?.call(widget.currentStep + 1);
      }
    }
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
                  color: Tema.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Tema.blanco, width: 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      _buildDropdown(
                        'Tipo de persona',
                        {'Natural': 1, 'Jurídica': 2},
                        valorSeleccionado: _tipoPersona,
                        onChanged: (value) => ref
                            .read(registerProvider.notifier)
                            .setTipoPersona(value ?? 0),
                      ),
                      const SizedBox(height: Constantes.separacion),
                      _buildDropdown(
                        'Tipo de documento',
                        {'DNI': 1, 'CE': 2, 'Pasaporte': 3},
                        valorSeleccionado: _tipoDocumento,
                        onChanged: (value) => ref
                            .read(registerProvider.notifier)
                            .setTipoDocumento(value ?? 0),
                      ),
                      const SizedBox(height: Constantes.separacion),
                      _buildTextField(
                        hint: 'Nro documento',
                        _numeroDocumentoController,
                        _numeroDocumentoFocus,
                        isDNI:
                            ref.watch(
                              registerProvider.select(
                                (state) => state.tipoDocumento,
                              ),
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
                      _buildDatePicker(
                        hint: 'Fecha de nacimiento',
                        _fechaNacimientoController,
                        _fechaNacimientoFocus,
                      ),
                      const SizedBox(height: Constantes.separacion),
                      _buildDropdown(
                        'Sexo',
                        {'Masculino': true, 'Femenino': false},
                        valorSeleccionado: _sexo,
                        onChanged: (value) => ref
                            .read(registerProvider.notifier)
                            .setSexo(value ?? true),
                      ),
                      const SizedBox(height: Constantes.separacion),
                      _buildTextField(
                        hint: 'Celular',
                        _celularController,
                        _celularFocus,
                        isCelular: true,
                      ),
                      const SizedBox(height: Constantes.separacion),
                      _buildTextField(
                        hint: 'Contacto',
                        _contactoController,
                        _contactoFocus,
                        isCelular: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Constantes.separacionFormulario),
              _buildContinueButton(context),
              const SizedBox(height: Constantes.separacionFormulario * 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(
    String label,
    Map<String, T> opciones, {
    T? valorSeleccionado,
    void Function(T?)? onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: valorSeleccionado,
      dropdownColor: Tema.blanco,
      style: const TextStyle(color: Colors.black87, fontSize: 14),
      iconEnabledColor: Tema.primaryColor,
      items: opciones.entries
          .map(
            (entry) =>
                DropdownMenuItem<T>(value: entry.value, child: Text(entry.key)),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: label,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Tema.blanco, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Tema.blanco, width: 2),
        ),
        errorStyle: const TextStyle(
          color: Tema.blanco,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      validator: (value) {
        return ref
            .read(registerProvider.notifier)
            .validarCampo(value.toString(), label);
      },
    );
  }

  Widget _buildTextField(
    TextEditingController? controller,
    FocusNode? focusNode, {
    required String hint,
    bool isPassword = false,
    bool isDNI = false,
    bool isCelular = false,
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
        ).textTheme.bodySmall!.copyWith(color: Tema.blanco),
        counterText: '',
      ),
      validator: (value) {
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

  Widget _buildDatePicker(
    TextEditingController? controller,
    FocusNode? focusNode, {
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      readOnly: true,
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
        errorStyle: Theme.of(
          context,
        ).textTheme.bodySmall!.copyWith(color: Tema.blanco),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
          firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
          lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
        );

        String formattedDate =
            '${pickedDate?.year}-${pickedDate?.month.toString().padLeft(2, '0')}-${pickedDate?.day.toString().padLeft(2, '0')}';

        pickedDate != null
            ? controller?.text = formattedDate
            : controller?.text = '';
      },
      validator: (value) {
        return ref.read(registerProvider.notifier).validarCampo(value!, hint);
      },
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50),
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          _handleContinue(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Tema.negro,
          foregroundColor: Tema.blanco,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Text(
          'Continuar',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Tema.blanco,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
