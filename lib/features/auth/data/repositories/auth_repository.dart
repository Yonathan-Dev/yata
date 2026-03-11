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

  Future<AuthModel> verificarCodigoOTP(
    String verificationToken,
    String codigoOtp,
    String fingerprint,
  ) async {
    return await dataSource.verificarCodigoOTP(
      verificationToken,
      codigoOtp,
      fingerprint,
    );
  }

  Future<void> logout(String refreshToken, String fingerprint) async {
    await dataSource.logout(refreshToken, fingerprint);
  }

  Future<String> restaurarClave(
    String correo,
    String numeroDocumento,
    String login,
  ) async {
    return await dataSource.restaurarClave(login, numeroDocumento, correo);
  }
}
