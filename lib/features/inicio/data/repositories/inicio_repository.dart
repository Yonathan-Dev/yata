import 'dart:core';

import '../../../../core/app_exports.dart';

class InicioRepository {
  final InicioDataSource dataSource;

  InicioRepository({required this.dataSource});

  Future<SaldoModel?> consultarSaldo(int idUsuario) async {
    final saldo = await dataSource.consultarSaldo(idUsuario);
    return saldo;
  }

  Future<List<InicioModel>> listarTodosyatas() async {
    final yatas = await dataSource.listarTodosyatas();
    return yatas;
  }
}
