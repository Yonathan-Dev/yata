import 'package:dio/dio.dart';

import '../../../../core/app_exports.dart';

class AuthDataSource {
  final Dio dio;

  AuthDataSource({required this.dio});

  //Login  con PIN
  Future<AuthModel> postAuthPin(
    String login,
    String pin,
    String fingerprint,
  ) async {
    try {
      final response = await dio.post(
        '/api/Usuario/loginConPin',
        data: {'login': login, 'pin': pin, 'fingerprint': fingerprint},
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

        // Validar código de respuesta
        final errorCodigo = data['errorCodigo'];
        if (errorCodigo != 'OK') {
          throw Exception(data['errorMensaje'] ?? 'Error desconocido');
        }

        // Obtener datos del usuario (value)
        final value = data['value'];
        if (value == null) {
          throw Exception('No se encontraron datos del usuario');
        }

        return AuthModel.fromJson(value);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthModel> loginConCorreo(
    String correo,
    String password,
    String fingerprint,
    String nombreDispositivo,
    String ipAddress,
    String userAgent,
  ) async {
    try {
      final response = await dio.post(
        '/api/Usuario/validarUsuario',
        data: {
          'correo': correo,
          'password': password,
          'fingerprint': fingerprint,
          'nombreDispositivo': nombreDispositivo,
          'ipAddress': ipAddress,
          'userAgent': userAgent,
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

        // Validar código de respuesta
        final errorCodigo = data['errorCodigo'];
        if (errorCodigo != 'OK') {
          throw Exception(data['errorMensaje'] ?? 'Error desconocido');
        }

        // Obtener datos del usuario (value)
        final value = data['value'];
        if (value == null) {
          throw Exception('No se encontraron datos del usuario');
        }

        return AuthModel.fromJson(value);
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
