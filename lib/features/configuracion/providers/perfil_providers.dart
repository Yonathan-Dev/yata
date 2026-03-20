// Modelo de registrar PIN
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

// Estado del perfil
class PerfilState {
  final int idUsuario;
  final String login;
  final String celular;
  final bool sexo;
  final String genero;
  final bool tienePinConfigurado;
  final int idPersona;
  final int idTipoDocumento;
  final String numeroDocumento;
  final String primerApellido;
  final String segundoApellido;
  final String nombres;
  final String fechaNacimiento;
  final String correo;
  final bool isLoading;
  final String mensaje;

  PerfilState({
    this.idUsuario = 0,
    this.login = '',
    this.celular = '',
    this.sexo = false,
    this.genero = '',
    this.tienePinConfigurado = false,
    this.idPersona = 1,
    this.idTipoDocumento = 1,
    this.numeroDocumento = '',
    this.primerApellido = '',
    this.segundoApellido = '',
    this.nombres = '',
    this.fechaNacimiento = '',
    this.correo = '',
    this.isLoading = false,
    this.mensaje = '',
  });

  PerfilState copyWith({
    int? idUsuario,
    String? login,
    String? celular,
    bool? sexo,
    String? genero,
    bool? tienePinConfigurado,
    int? idPersona,
    int? idTipoDocumento,
    String? numeroDocumento,
    String? primerApellido,
    String? segundoApellido,
    String? nombres,
    String? fechaNacimiento,
    String? correo,
    bool? isLoading,
    String? mensaje,
  }) {
    return PerfilState(
      idUsuario: idUsuario ?? this.idUsuario,
      login: login ?? this.login,
      celular: celular ?? this.celular,
      sexo: sexo ?? this.sexo,
      genero: genero ?? this.genero,
      tienePinConfigurado: tienePinConfigurado ?? this.tienePinConfigurado,
      idPersona: idPersona ?? this.idPersona,
      idTipoDocumento: idTipoDocumento ?? this.idTipoDocumento,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
      primerApellido: primerApellido ?? this.primerApellido,
      segundoApellido: segundoApellido ?? this.segundoApellido,
      nombres: nombres ?? this.nombres,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      correo: correo ?? this.correo,
      isLoading: isLoading ?? this.isLoading,
      mensaje: mensaje ?? this.mensaje,
    );
  }
}

// Notifier para manejar el estado de perfil
class PerfilNotifier extends Notifier<PerfilState> {
  @override
  PerfilState build() {
    return PerfilState();
  }

  void setIdUsuario(int value) {
    state = state.copyWith(idUsuario: value);
  }

  void setLogin(String value) {
    state = state.copyWith(login: value);
  }

  void setCelular(String value) {
    state = state.copyWith(celular: value);
  }

  void setSexo(bool value) {
    state = state.copyWith(sexo: value);
  }

  void setGenero(String value) {
    state = state.copyWith(genero: value);
  }

  void setTienePinConfigurado(bool value) {
    state = state.copyWith(tienePinConfigurado: value);
  }

  void setIdPersona(int value) {
    state = state.copyWith(idPersona: value);
  }

  void setIdTipoDocumento(int value) {
    state = state.copyWith(idTipoDocumento: value);
  }

  void setNombres(String value) {
    state = state.copyWith(nombres: value);
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

  void setFechaNacimiento(String value) {
    state = state.copyWith(fechaNacimiento: value);
  }

  void setCorreo(String value) {
    state = state.copyWith(correo: value);
  }

  void setIsLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void setMensaje(String value) {
    state = state.copyWith(mensaje: value);
  }

  void resetEstado() {
    state = PerfilState();
  }

  //validar campo
  String? validarCampo(String value, String campo) {
    if (value.isEmpty || value == 'null') {
      return 'El campo $campo es obligatorio';
    }
    return null;
  }

  void capturarDatosPerfil({
    required int idUsuario,
    required String login,
    required String celular,
    required bool sexo,
    required String genero,
    required bool tienePinConfigurado,
    required int idPersona,
    required int idTipoDocumento,
    required String numeroDocumento,
    required String primerApellido,
    required String segundoApellido,
    required String nombres,
    required String fechaNacimiento,
    required String correo,
  }) {
    state = state.copyWith(
      idUsuario: idUsuario,
      login: login,
      celular: celular,
      sexo: sexo,
      genero: genero,
      tienePinConfigurado: tienePinConfigurado,
      idPersona: idPersona,
      idTipoDocumento: idTipoDocumento,
      numeroDocumento: numeroDocumento,
      primerApellido: primerApellido,
      segundoApellido: segundoApellido,
      nombres: nombres,
      fechaNacimiento: fechaNacimiento,
      correo: correo,
    );
  }
}

final perfilProvider = NotifierProvider<PerfilNotifier, PerfilState>(
  () => PerfilNotifier(),
);

final perfilDataSourceProvider = Provider<ConfiguracionDataSource>((ref) {
  final dio = ref.read(dioYataAuthProvider);
  return ConfiguracionDataSource(dio: dio);
});

final perfilRepositoryProvider = Provider<ConfiguracionRepository>((ref) {
  final dataSource = ref.read(perfilDataSourceProvider);
  return ConfiguracionRepository(dataSource: dataSource);
});

final obtenerPerfilProvider = FutureProvider<PerfilModel>((ref) async {
  final repository = ref.watch(perfilRepositoryProvider);
  final idUsuario = ref.watch(authProvider).user?.idUsuario ?? 0;
  return await repository.obtenerPerfil(idUsuario);
});

final modificarPerfilProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(perfilRepositoryProvider);
  final perfilState = ref.watch(perfilProvider);
  return await repository.modificarPerfil(
    perfilState.idUsuario,
    perfilState.idPersona,
    perfilState.idTipoDocumento,
    perfilState.numeroDocumento,
    perfilState.primerApellido,
    perfilState.segundoApellido,
    perfilState.nombres,
    perfilState.fechaNacimiento,
    perfilState.sexo,
    perfilState.correo,
    perfilState.celular,
  );
});
