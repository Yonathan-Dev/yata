import 'dart:core';

import 'package:dio/dio.dart';

import '../../../../core/app_exports.dart';

class InicioDataSource {
  final Dio dio;

  InicioDataSource({required this.dio});
  Future<SaldoModel> consultarSaldo(int idUsuario) async {
    try {
      final response = await dio.get(
        '/api/Payin/saldo/$idUsuario',
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(milliseconds: 30000),
          receiveTimeout: Duration(milliseconds: 30000),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data == null) {
          throw Exception('Respuesta vacía del servidor');
        }

        final success = data['success'] as bool? ?? false;
        if (!success) {
          throw Exception('Error en la respuesta del servidor');
        }

        return SaldoModel.fromJson(data);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<MovimientoModel> consultarMovimientos(
    int idUsuario,
    int page,
    int pageSize,
  ) async {
    try {
      final response = await dio.get(
        '/api/Payin/movimientos',
        queryParameters: {
          'idusuario': idUsuario,
          'page': page,
          'pageSize': pageSize,
          'idestado': null,
          'tipo': null,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(milliseconds: 30000),
          receiveTimeout: Duration(milliseconds: 30000),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data == null) {
          throw Exception('Respuesta vacía del servidor');
        }

        final success = data['success'] as bool? ?? false;
        if (!success) {
          throw Exception('Error en la respuesta del servidor');
        }

        return MovimientoModel.fromJson(data);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
