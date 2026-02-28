import 'dart:core';

import '../../../../core/app_exports.dart';

class InicioRepository {
  final InicioDataSource dataSource;

  InicioRepository({required this.dataSource});

  Future<InicioModel?> listaryata(int codigo) async {
    final yata = await dataSource.listaryata(codigo);
    return yata;
  }

  Future<List<InicioModel>> listarTodosyatas() async {
    final yatas = await dataSource.listarTodosyatas();
    return yatas;
  }
}
