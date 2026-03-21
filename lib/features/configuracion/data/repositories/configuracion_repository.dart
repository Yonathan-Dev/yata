import '../../../../core/app_exports.dart';

class ConfiguracionRepository {
  final ConfiguracionDataSource dataSource;

  ConfiguracionRepository({required this.dataSource});

  Future<PerfilModel> obtenerPerfil(int idUsuario) async {
    return await dataSource.obtenerPerfil(idUsuario);
  }

  Future<String> modificarPerfil(
    int idUsuario,
    int idTipoPersona,
    int idTipoDocumento,
    String numeroDocumento,
    String primerApellido,
    String segundoApellido,
    String nombres,
    String fechaNacimiento,
    bool sexo,
    String correo,
    String celular,
  ) async {
    return await dataSource.modificarPerfil(
      idUsuario,
      idTipoPersona,
      idTipoDocumento,
      numeroDocumento,
      primerApellido,
      segundoApellido,
      nombres,
      fechaNacimiento,
      sexo,
      correo,
      celular,
    );
  }

  Future<String> solicitarCodigoOtp(int idUsuario, String login) async {
    return await dataSource.solicitarCodigoOtp(idUsuario, login);
  }

  Future<String> enviarVerificacionCodigoOTP(
    String correo,
    String codigoOtp,
  ) async {
    return await dataSource.enviarVerificacionCodigoOTP(correo, codigoOtp);
  }

  Future<String> solicitarCambioConstrasena(
    int idUsuario,
    String login,
    String contrasenaActual,
    String nuevaContrasena,
    String codigoOtp,
  ) async {
    return await dataSource.solicitarCambioConstrasena(
      idUsuario,
      login,
      contrasenaActual,
      nuevaContrasena,
      codigoOtp,
    );
  }
}
