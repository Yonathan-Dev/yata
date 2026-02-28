import '../../../../core/app_exports.dart';

class RegisterRepository {
  final RegisterDataSource dataSource;

  RegisterRepository({required this.dataSource});

  Future<String> enviarVerificacionOTP(RegisterState state) async {
    try {
      final response = await dataSource.enviarVerificacionOTP(
        state.correo,
        state.pcIp,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
