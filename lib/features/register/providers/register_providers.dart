import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

// Modelo de estado registrar
class RegisterState {
  final String nombre;
  final String apellidos;
  final String documentoIdentidad;
  final String pais;
  final String departamento;
  final String ciudad;
  final String fechaNacimiento;
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
    this.nombre = '',
    this.apellidos = '',
    this.documentoIdentidad = '',
    this.pais = '',
    this.departamento = '',
    this.ciudad = '',
    this.fechaNacimiento = '',
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
    String? nombre,
    String? apellidos,
    String? documentoIdentidad,
    String? pais,
    String? departamento,
    String? ciudad,
    String? fechaNacimiento,
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
      nombre: nombre ?? this.nombre,
      apellidos: apellidos ?? this.apellidos,
      documentoIdentidad: documentoIdentidad ?? this.documentoIdentidad,
      pais: pais ?? this.pais,
      departamento: departamento ?? this.departamento,
      ciudad: ciudad ?? this.ciudad,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
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

  void setNombre(String value) {
    state = state.copyWith(nombre: value);
  }

  void setApellidos(String value) {
    state = state.copyWith(apellidos: value);
  }

  void setDocumentoIdentidad(String value) {
    state = state.copyWith(documentoIdentidad: value);
  }

  void setPais(String value) {
    state = state.copyWith(pais: value);
  }

  void setDepartamento(String value) {
    state = state.copyWith(departamento: value);
  }

  void setCiudad(String value) {
    state = state.copyWith(ciudad: value);
  }

  void setFechaNacimiento(String value) {
    state = state.copyWith(fechaNacimiento: value);
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
    if (value.isEmpty) {
      return 'El campo $campo es obligatorio';
    }
    return null;
  }

  String? validarCorreo(String value) {
    if (value.isEmpty) {
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
    required String nombre,
    required String apellidos,
    required String documentoIdentidad,
    required String pais,
    required String departamento,
    required String ciudad,
    required String fechaNacimiento,
    required String imagen1,
    required String rutaImagen1,
    required String correo,
    required String confirmaCorreo,
    required String contrasena,
    required String confirmaContrasena,
  }) {
    state = state.copyWith(
      nombre: nombre,
      apellidos: apellidos,
      documentoIdentidad: documentoIdentidad,
      pais: pais,
      departamento: departamento,
      ciudad: ciudad,
      fechaNacimiento: fechaNacimiento,
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
