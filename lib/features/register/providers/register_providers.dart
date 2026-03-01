import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

// Modelo de estado registrar
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
  final String rutaImagen1;
  final String correo;
  final String confirmaCorreo;
  final String contrasena;
  final String confirmaContrasena;
  final String pcIp;
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
    this.rutaImagen1 = '',
    this.correo = '',
    this.confirmaCorreo = '',
    this.contrasena = '',
    this.confirmaContrasena = '',
    this.pcIp = '',
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
    String? rutaImagen1,
    String? correo,
    String? confirmaCorreo,
    String? contrasena,
    String? confirmaContrasena,
    String? pcIp,
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
      rutaImagen1: rutaImagen1 ?? this.rutaImagen1,
      correo: correo ?? this.correo,
      confirmaCorreo: confirmaCorreo ?? this.confirmaCorreo,
      contrasena: contrasena ?? this.contrasena,
      confirmaContrasena: confirmaContrasena ?? this.confirmaContrasena,
      pcIp: pcIp ?? this.pcIp,
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
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  String? validarCorreos(String correo, String confirmaCorreo) {
    if (correo.isEmpty || confirmaCorreo.isEmpty) {
      return 'Ambos campos de correo son obligatorios';
    }
    if (correo != confirmaCorreo) {
      return 'Los correos no coinciden';
    }
    return null;
  }

  String? validarContrasenas(String contrasena, String confirmaContrasena) {
    if (contrasena.isEmpty || confirmaContrasena.isEmpty) {
      return 'Ambos campos de contraseña son obligatorios';
    }
    if (contrasena != confirmaContrasena) {
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
    required String rutaImagen1,
    required String correo,
    required String confirmaCorreo,
    required String contrasena,
    required String confirmaContrasena,
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
      rutaImagen1: rutaImagen1,
      correo: correo,
      confirmaCorreo: confirmaCorreo,
      contrasena: contrasena,
      confirmaContrasena: confirmaContrasena,
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

final acceptTermsProvider = StateProvider<bool>((ref) => false);
final acceptDataPolicyProvider = StateProvider<bool>((ref) => false);
final acceptPromotionsProvider = StateProvider<bool>((ref) => false);

final enviarOTPProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(registerRepositoryProvider);
  final state = ref.watch(registerProvider);
  return await repository.enviarVerificacionOTP(state);
});
