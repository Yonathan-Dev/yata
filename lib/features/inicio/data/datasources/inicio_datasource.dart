import 'dart:convert';
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

  //cuando tenemos una lista usar esta forma, si es un solo objeto usar la forma anterior
  Future<List<InicioModel>> listarTodosyatas() async {
    try {
      final response = await dio.post(
        '/api/wsyata/listar-yata',
        data: jsonEncode({'iCodigoyata': 1}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      final Map<String, dynamic> jsonResponse = response.data is String
          ? jsonDecode(response.data as String)
          : response.data as Map<String, dynamic>;

      final data = jsonResponse["data"];
      final error = data?["error"];

      if (error != null && error["xidError"] == 200) {
        final objects = data["objects"];
        final table1 = objects?["table1"];
        final dataList = table1?["data"] as List?;

        if (dataList != null && dataList.isNotEmpty) {
          return dataList
              .map((item) => InicioModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          return [];
        }
      } else {
        final mensajeError = error?["msjError"] ?? "Error desconocido";
        throw Exception(mensajeError);
      }
    } on DioException catch (e) {
      throw Exception('Error en la solicitud: ${e.message}');
    } catch (e) {
      throw Exception('Error al procesar la respuesta: $e');
    }
  }
}
