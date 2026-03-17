import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

// Modelo de estado registrar
class RegistrarStateOperaciones {
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
  final List<RecursoModel> recursos;
  final String error;
  final bool isLoading;
  final String mensaje;

  RegistrarStateOperaciones({
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
    this.recursos = const [],
    this.error = '',
    this.isLoading = false,
    this.mensaje = '',
  });

  RegistrarStateOperaciones copyWith({
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
    List<RecursoModel>? recursos,
    String? error,
    bool? isLoading,
    String? mensaje,
  }) {
    return RegistrarStateOperaciones(
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
      recursos: recursos ?? this.recursos,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      mensaje: mensaje ?? this.mensaje,
    );
  }
}

// Notifier para manejar el estado de ubicación
class RegistrarNotifier extends Notifier<RegistrarStateOperaciones> {
  @override
  RegistrarStateOperaciones build() {
    return RegistrarStateOperaciones();
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
    state = RegistrarStateOperaciones();
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
      recursos: recursos,
    );
  }
}

final registrarProvider =
    NotifierProvider<RegistrarNotifier, RegistrarStateOperaciones>(() {
      return RegistrarNotifier();
    });

//Provider para enviar registros
final enviarRegistroProvider = FutureProvider.autoDispose<String>((ref) async {
  final repository = ref.watch(registrarRepositoryProvider);
  final registrarState = ref.read(registrarProvider);
  final vFechaEvento = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
  final vUsuario = ref.watch(authProvider).user?.login;
  final seguimiento = ref.watch(seguimientoProvider);
  return await repository.enviarRegistro(
    vUsuario!,
    vFechaEvento,
    registrarState,
    seguimiento,
  );
});

final uploadFotoProvider = FutureProvider.autoDispose.family<String, File>((
  ref,
  imageFile,
) async {
  final repository = ref.watch(registrarRepositoryProvider);
  final tokenStorage = ref.watch(tokenProvider);
  return await repository.uploadFoto(imageFile, tokenStorage);
});

final registrarRepositoryProvider = Provider<RegistrarRepository>((ref) {
  final dataSource = ref.watch(registrarDataSourceProvider);
  return RegistrarRepository(dataSource: dataSource);
});

final registrarDataSourceProvider = Provider<RegistrarDataSource>((ref) {
  final dio = ref.watch(dioYataProvider);
  return RegistrarDataSource(dio: dio);
});

final seguimientoProvider = StateProvider<String>((ref) {
  return '';
});
