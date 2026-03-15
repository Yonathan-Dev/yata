import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

// Modelo de registrar
class RegisterState {
  final int tipoPersona;
  final int tipoDocumento;
  final String numeroDocumento;
  final String primerApellido;
  final String segundoApellido;
  final String nombres;
  final String fechaNacimiento;
  final bool sexo;
  final String celular;
  final String contacto;
  final String imagen1;
  final String imagen1Base64;
  final String rutaImagen1;
  final String correo;
  final String confirmaCorreo;
  final String contrasena;
  final String confirmaContrasena;
  final String pcIp;
  final bool terminos;
  final bool politicaDatos;
  final bool promociones;
  final String error;
  final bool isLoading;
  final String mensaje;

  RegisterState({
    this.tipoPersona = 0,
    this.tipoDocumento = 0,
    this.numeroDocumento = '',
    this.primerApellido = '',
    this.segundoApellido = '',
    this.nombres = '',
    this.fechaNacimiento = '',
    this.sexo = false,
    this.celular = '',
    this.contacto = '',
    this.imagen1 = '',
    this.imagen1Base64 = '',
    this.rutaImagen1 = '',
    this.correo = '',
    this.confirmaCorreo = '',
    this.contrasena = '',
    this.confirmaContrasena = '',
    this.pcIp = '0.0.0.0',
    this.terminos = false,
    this.politicaDatos = false,
    this.promociones = false,
    this.error = '',
    this.isLoading = false,
    this.mensaje = '',
  });

  RegisterState copyWith({
    int? tipoPersona,
    int? tipoDocumento,
    String? numeroDocumento,
    String? primerApellido,
    String? segundoApellido,
    String? nombres,
    String? fechaNacimiento,
    bool? sexo,
    String? celular,
    String? contacto,
    String? imagen1,
    String? imagen1Base64,
    String? rutaImagen1,
    String? correo,
    String? confirmaCorreo,
    String? contrasena,
    String? confirmaContrasena,
    String? pcIp,
    bool? terminos,
    bool? politicaDatos,
    bool? promociones,
    String? error,
    bool? isLoading,
    String? mensaje,
  }) {
    return RegisterState(
      tipoPersona: tipoPersona ?? this.tipoPersona,
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
      primerApellido: primerApellido ?? this.primerApellido,
      segundoApellido: segundoApellido ?? this.segundoApellido,
      nombres: nombres ?? this.nombres,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      sexo: sexo ?? this.sexo,
      celular: celular ?? this.celular,
      contacto: contacto ?? this.contacto,
      imagen1: imagen1 ?? this.imagen1,
      imagen1Base64: imagen1Base64 ?? this.imagen1Base64,
      rutaImagen1: rutaImagen1 ?? this.rutaImagen1,
      correo: correo ?? this.correo,
      confirmaCorreo: confirmaCorreo ?? this.confirmaCorreo,
      contrasena: contrasena ?? this.contrasena,
      confirmaContrasena: confirmaContrasena ?? this.confirmaContrasena,
      pcIp: pcIp ?? this.pcIp,
      terminos: terminos ?? this.terminos,
      politicaDatos: politicaDatos ?? this.politicaDatos,
      promociones: promociones ?? this.promociones,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      mensaje: mensaje ?? this.mensaje,
    );
  }
}

// Notifier para manejar el estado de ubicación
class RegisterNotifier extends Notifier<RegisterState> {
  @override
  RegisterState build() {
    return RegisterState();
  }

  void setTipoPersona(int value) {
    state = state.copyWith(tipoPersona: value);
  }

  void setTipoDocumento(int value) {
    state = state.copyWith(tipoDocumento: value);
  }

  void setNumeroDocumento(String value) {
    state = state.copyWith(numeroDocumento: value);
  }

  void setPrimerApellido(String value) {
    state = state.copyWith(primerApellido: value);
  }

  void setSegundoApellido(String value) {
    state = state.copyWith(segundoApellido: value);
  }

  void setNombres(String value) {
    state = state.copyWith(nombres: value);
  }

  void setFechaNacimiento(String value) {
    state = state.copyWith(fechaNacimiento: value);
  }

  void setSexo(bool value) {
    state = state.copyWith(sexo: value);
  }

  void setCelular(String value) {
    state = state.copyWith(celular: value);
  }

  void setContacto(String value) {
    state = state.copyWith(contacto: value);
  }

  void setImagen1(String value) {
    state = state.copyWith(imagen1: value);
  }

  void setImagen1Base64(String value) {
    state = state.copyWith(imagen1Base64: value);
  }

  void setRutaImagen1(String value) {
    state = state.copyWith(rutaImagen1: value);
  }

  void setCorreo(String value) {
    state = state.copyWith(correo: value);
  }

  void setConfirmaCorreo(String value) {
    state = state.copyWith(confirmaCorreo: value);
  }

  void setContrasena(String value) {
    state = state.copyWith(contrasena: value);
  }

  void setConfirmaContrasena(String value) {
    state = state.copyWith(confirmaContrasena: value);
  }

  void setPcIp(String value) {
    state = state.copyWith(pcIp: value);
  }

  void setTerminos(bool value) {
    state = state.copyWith(terminos: value);
  }

  void setPoliticaDatos(bool value) {
    state = state.copyWith(politicaDatos: value);
  }

  void setPromociones(bool value) {
    state = state.copyWith(promociones: value);
  }

  void setError(String value) {
    state = state.copyWith(error: value);
  }

  void setIsLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void setMensaje(String value) {
    state = state.copyWith(mensaje: value);
  }

  void resetEstado() {
    state = RegisterState();
  }

  //validar campo
  String? validarCampo(String value, String campo) {
    if (value.isEmpty || value == 'null') {
      return 'El campo $campo es obligatorio';
    }
    return null;
  }

  String? validarCorreo(String value) {
    if (value.isEmpty || value == 'null') {
      return 'El campo correo es obligatorio';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un correo válido';
    }
    return null;
  }

  String? validarContrasena(String value) {
    if (value.isEmpty) {
      return 'El campo contraseña es obligatorio';
    }
    if (value.length < 8) {
      return 'Contraseña mínimo 8 caracteres';
    }
    return null;
  }

  String? validarCorreos() {
    if (state.correo.isEmpty || state.confirmaCorreo.isEmpty) {
      return 'Ambos campos de correo son obligatorios';
    }
    if (state.correo != state.confirmaCorreo) {
      return 'Los correos no coinciden';
    }
    return null;
  }

  String? validarContrasenas() {
    if (state.contrasena.isEmpty || state.confirmaContrasena.isEmpty) {
      return 'Ambos campos de contraseña son obligatorios';
    }
    if (state.contrasena != state.confirmaContrasena) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  void capturarDatosRegistrar({
    required int tipoPersona,
    required int tipoDocumento,
    required String numeroDocumento,
    required String primerApellido,
    required String segundoApellido,
    required String nombres,
    required String fechaNacimiento,
    required bool sexo,
    required String celular,
    required String contacto,
    required String imagen1,
    required String imagen1Base64,
    required String rutaImagen1,
    required String correo,
    required String confirmaCorreo,
    required String contrasena,
    required String confirmaContrasena,
    required String pcIp,
    required bool terminos,
    required bool politicaDatos,
    required bool promociones,
  }) {
    state = state.copyWith(
      tipoPersona: tipoPersona,
      tipoDocumento: tipoDocumento,
      numeroDocumento: numeroDocumento,
      primerApellido: primerApellido,
      segundoApellido: segundoApellido,
      nombres: nombres,
      fechaNacimiento: fechaNacimiento,
      sexo: sexo,
      celular: celular,
      contacto: contacto,
      imagen1: imagen1,
      imagen1Base64: imagen1Base64,
      rutaImagen1: rutaImagen1,
      correo: correo,
      confirmaCorreo: confirmaCorreo,
      contrasena: contrasena,
      confirmaContrasena: confirmaContrasena,
      pcIp: pcIp,
      terminos: terminos,
      politicaDatos: politicaDatos,
      promociones: promociones,
    );
  }
}

final registerProvider = NotifierProvider<RegisterNotifier, RegisterState>(() {
  return RegisterNotifier();
});

final registerRepositoryProvider = Provider<RegisterRepository>((ref) {
  final dataSource = ref.watch(registerDataSourceProvider);
  return RegisterRepository(dataSource: dataSource);
});

final registerDataSourceProvider = Provider<RegisterDataSource>((ref) {
  final dio = ref.watch(dioYataProvider);
  return RegisterDataSource(dio: dio);
});

final enviarOTPProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(registerRepositoryProvider);
  final state = ref.watch(registerProvider);
  return await repository.enviarVerificacionOTP(state);
});

final registrarCuentaProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(registerRepositoryProvider);
  final state = ref.watch(registerProvider);
  final pinState = ref.watch(registerPinProvider);
  final fingerprintState = await ref.watch(fingerPrintProvider.future);
  return await repository.registrarCuenta(state, pinState, fingerprintState);
});

final currentStepProvider = StateProvider<int>((ref) => 0);
