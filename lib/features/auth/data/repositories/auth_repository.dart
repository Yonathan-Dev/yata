import '../../../../core/app_exports.dart';

class AuthRepository {
  final AuthDataSource dataSource;

  AuthRepository({required this.dataSource});

  Future<AuthModel> postAuthPin(
    String login,
    String pin,
    String fingerprint,
  ) async {
    return await dataSource.postAuthPin(login, pin, fingerprint);
  }

  Future<AuthModel> loginConCorreo(
    String correo,
    String password,
    String fingerprint,
    String nombreDispositivo,
    String ipAddress,
    String userAgent,
  ) async {
    return await dataSource.loginConCorreo(
      correo,
      password,
      fingerprint,
      nombreDispositivo,
      ipAddress,
      userAgent,
    );
  }
}
