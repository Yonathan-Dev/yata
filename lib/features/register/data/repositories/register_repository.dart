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

  Future<String> enviarVerificacionCodigoOTP(
    VerifyCodeState state,
    RegisterState registerState,
  ) async {
    try {
      final response = await dataSource.enviarVerificacionCodigoOTP(
        registerState.correo,
        state.codigoOtp,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> registrarCuenta(
    RegisterState registerState,
    RegisterPinState pinState,
  ) async {
    try {
      final response = await dataSource.registrarCuenta(
        registerState,
        pinState,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
