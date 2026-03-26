import 'dart:core';

import '../../../../core/app_exports.dart';

class InicioRepository {
  final InicioDataSource dataSource;

  InicioRepository({required this.dataSource});

  Future<SaldoModel?> consultarSaldo(int idUsuario) async {
    final saldo = await dataSource.consultarSaldo(idUsuario);
    return saldo;
  }

  Future<MovimientoModel?> consultarMovimientos(
    int idUsuario,
    int page,
    int pageSize,
  ) async {
    final movimientos = await dataSource.consultarMovimientos(
      idUsuario,
      page,
      pageSize,
    );
    return movimientos;
  }
}
