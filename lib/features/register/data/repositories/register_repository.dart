import '../../../../core/app_exports.dart';

class RegisterRepository {
  final RegisterDataSource dataSource;

  RegisterRepository({required this.dataSource});

  Future<String> enviarRegistro(
    String vUsuario,
    String vFechaEvento,
    RegistrarState state,
    String vEvento,
  ) async {
    try {
      final response = await dataSource.enviarRegistro(
        vUsuario,
        vFechaEvento,
        state.codigo,
        state.nombre,
        state.alerta,
        state.estado,
        state.observacion,
        vEvento,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
