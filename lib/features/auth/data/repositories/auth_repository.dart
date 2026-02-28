import '../../../../core/app_exports.dart';

class AuthRepository {
  final AuthDataSource dataSource;

  AuthRepository({required this.dataSource});

  Future<AuthModel> postAuth(
    String login,
    String clave,
    String plataforma,
  ) async {
    return await dataSource.postAuth(login, clave, plataforma);
  }
}
