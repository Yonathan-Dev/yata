import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/app_exports.dart';

class ParatiDataSource {
  final Dio dio;

  ParatiDataSource({required this.dio});

  Future<List<ParatiModel>> obtenerRegistro(int iCodigoyata) async {
    try {
      final response = await dio.post(
        '/api/wsFichayata/obtener-registros',
        data: jsonEncode({'iCodigoyata': iCodigoyata}),
        options: Options(
          headers: {'accept': 'text/plain', 'Content-Type': 'application/json'},
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );

      String responseData = response.data is String
          ? response.data as String
          : jsonEncode(response.data);

      // Remover comillas externas si existen
      if (responseData.startsWith('"') && responseData.endsWith('"')) {
        responseData = responseData.substring(1, responseData.length - 1);
        // Decodificar caracteres escapados
        responseData = responseData.replaceAll('\\"', '"');
      }

      // Agregar llaves si faltan
      if (!responseData.startsWith('{') && responseData.contains('"data":')) {
        responseData = '{$responseData}';
      }

      final Map<String, dynamic> jsonData = json.decode(responseData);
      final data = jsonData["data"];
      final error = data?["error"];

      if (error != null && error["xidError"] == 200) {
        final table1 = data["objects"]?["table1"];
        if (table1 != null && table1["data"] != null) {
          final List<dynamic> dataList = table1["data"];
          return dataList.map((item) => ParatiModel.fromJson(item)).toList();
        }
        return [];
      } else {
        final mensajeError = error?["msjError"] ?? "Error desconocido";
        throw Exception(mensajeError);
      }
    } on DioException catch (e, stackTrace) {
      // Manejar errores de Dio
      throw Exception('Error en la solicitud: ${e.message}\n$stackTrace');
    } catch (e) {
      // Capturar errores de parseo JSON
      throw Exception('Error al procesar la respuesta del servidor: $e');
    }
  }
}
