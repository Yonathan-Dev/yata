import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../core/app_exports.dart';

class RegistrarDataSource {
  final Dio dio;

  RegistrarDataSource({required this.dio});

  Future<String> enviarRegistro(
    String vUsuario,
    String vFechaEvento,
    int iCodigoyata,
    String vNombreyata,
    String vAlerta,
    String vEstado,
    String vObservacion,
    String vEvento,
    Map<String, dynamic> requestData,
  ) async {
    try {
      final response = await dio.post(
        '/api/wsFichayata/registrar-datos',
        data: jsonEncode({
          'vUsuario': vUsuario,
          'vFechaEvento': vFechaEvento,
          'iCodigoyata': iCodigoyata,
          'vAlerta': vAlerta,
          'vNombreyata': vNombreyata,
          'vEstado': vEstado,
          'vObservacion': vObservacion,
          'vEvento': vEvento,
          'data': requestData,
        }),
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
        return error["msjError"] ?? '';
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

  Future<String> uploadFoto(File imageFile, String tokenStorage) async {
    final url = (dotenv.env['URL_STORAGE'] ?? '').trim();
    final token = tokenStorage;
    final instanceId = (dotenv.env['INSTANCED_STORAGE'] ?? '').trim();
    try {
      // Crear cliente HTTP con timeout configurado
      final client = http.Client();

      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          filename: basename(imageFile.path),
          contentType: MediaType('image', 'jpeg'),
        ),
      );
      request.fields['token'] = token;
      request.fields['instanceId'] = instanceId;

      // Enviar con timeout de 3 minutos
      final streamedResponse = await client
          .send(request)
          .timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);
      client.close();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse["fileId"] ?? '';
      } else {
        throw 'Error al subir la foto. Status: ${response.statusCode}, Response: ${response.body}';
      }
    } on TimeoutException {
      throw 'El servidor tardó demasiado en responder. Por favor, verifica tu conexión e intenta nuevamente.';
    } on SocketException {
      throw 'No se pudo conectar al servidor. Verifica tu conexión a internet.';
    } catch (e) {
      throw 'Error al subir la foto';
    }
  }

  //obtener mediante el operador el yata asignado
  Future<YataModel?> obteneryataOperador(String vUsuario) async {
    try {
      final response = await dio.post(
        '/api/wsyata/obtener-yata-operador',
        data: jsonEncode({'vUsuario': vUsuario}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
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
        final length = table1?["length"] ?? 0;

        if (length > 0) {
          final yataData = table1["data"];
          return YataModel.fromMap(yataData);
        } else {
          return null;
        }
      } else {
        final mensajeError = error?["msjError"] ?? "Error desconocido";
        throw Exception(mensajeError);
      }
    } on DioException catch (e, stackTrace) {
      throw Exception('Error en la solicitud: ${e.message}\n$stackTrace');
    } catch (e) {
      throw Exception('Error al procesar la respuesta del servidor: $e');
    }
  }
}
