import '../../../../core/app_exports.dart';

class ConfiguracionRepository {
  final ConfiguracionDataSource dataSource;

  ConfiguracionRepository({required this.dataSource});

  Future<PerfilModel> obtenerPerfil(int idUsuario) async {
    return await dataSource.obtenerPerfil(idUsuario);
  }
}
