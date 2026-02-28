import '../../../../core/app_exports.dart';

class ParatiRepository {
  final ParatiDataSource dataSource;

  ParatiRepository({required this.dataSource});

  Future<List<ParatiModel>> obtenerRegistro(int iCodigoyata) async {
    try {
      final response = await dataSource.obtenerRegistro(iCodigoyata);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
