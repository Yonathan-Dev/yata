import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

// Modelo de estado registrar
class RegisterState {
  final int codigo;
  final String nombre;
  final String unidadOperativa;
  final String estado;
  final String tipo;
  final String alerta;
  final String observacion;
  final String imagen1; // fileId del servidor
  final String imagen2; // fileId del servidor
  final String rutaImagen1; // ruta local del archivo
  final String rutaImagen2;
  final String error;
  final bool isLoading;
  final String mensaje;

  RegisterState({
    this.codigo = 0,
    this.nombre = '',
    this.unidadOperativa = '',
    this.estado = '',
    this.tipo = '',
    this.alerta = '',
    this.observacion = '',
    this.imagen1 = '',
    this.imagen2 = '',
    this.rutaImagen1 = '',
    this.rutaImagen2 = '',
    this.error = '',
    this.isLoading = false,
    this.mensaje = '',
  });

  RegisterState copyWith({
    int? codigo,
    String? nombre,
    String? unidadOperativa,
    String? estado,
    String? tipo,
    String? alerta,
    String? observacion,
    String? imagen1,
    String? imagen2,
    String? rutaImagen1,
    String? rutaImagen2,
    String? error,
    bool? isLoading,
    String? mensaje,
  }) {
    return RegisterState(
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      unidadOperativa: unidadOperativa ?? this.unidadOperativa,
      estado: estado ?? this.estado,
      tipo: tipo ?? this.tipo,
      alerta: alerta ?? this.alerta,
      observacion: observacion ?? this.observacion,
      imagen1: imagen1 ?? this.imagen1,
      imagen2: imagen2 ?? this.imagen2,
      rutaImagen1: rutaImagen1 ?? this.rutaImagen1,
      rutaImagen2: rutaImagen2 ?? this.rutaImagen2,
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

  void setCodigo(int value) {
    state = state.copyWith(codigo: value);
  }

  void setNombre(String value) {
    state = state.copyWith(nombre: value);
  }

  void setUnidadOperativa(String value) {
    state = state.copyWith(unidadOperativa: value);
  }

  void setEstado(String value) {
    state = state.copyWith(estado: value);
  }

  void setTipo(String value) {
    state = state.copyWith(tipo: value);
  }

  void setAlerta(String value) {
    state = state.copyWith(alerta: value);
  }

  void setObservacion(String value) {
    state = state.copyWith(observacion: value);
  }

  void setImagen1(String value) {
    state = state.copyWith(imagen1: value);
  }

  void setImagen2(String value) {
    state = state.copyWith(imagen2: value);
  }

  void setRutaImagen1(String value) {
    state = state.copyWith(rutaImagen1: value);
  }

  void setRutaImagen2(String value) {
    state = state.copyWith(rutaImagen2: value);
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

  void capturarDatosRegistrar({
    required int codigo,
    required String nombre,
    required String unidadOperativa,
    required String estado,
    required String tipo,
    required String alerta,
    required String observacion,
    required String imagen1,
    required String imagen2,
    required List<RecursoModel> recursos,
  }) {
    state = state.copyWith(
      codigo: codigo,
      nombre: nombre,
      unidadOperativa: unidadOperativa,
      estado: estado,
      tipo: tipo,
      alerta: alerta,
      observacion: observacion,
      imagen1: imagen1,
      imagen2: imagen2,
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
  final dio = ref.watch(dioEmergenciasProvider);
  return RegisterDataSource(dio: dio);
});
