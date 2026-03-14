import 'package:dio/dio.dart';

import '../../../../core/app_exports.dart';

class AuthDataSource {
  final Dio dio;

  AuthDataSource({required this.dio});

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

  Future<AuthModel> verificarCodigoOTP(
    String verificationToken,
    String codigoOtp,
    String fingerprint,
  ) async {
    try {
      final response = await dio.post(
        '/api/Usuario/verificar-dispositivo',
        data: {
          'verificationToken': verificationToken,
          'codigo': codigoOtp,
          'fingerprint': fingerprint,
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

  Future<bool> logout(String refreshToken, String fingerprint) async {
    try {
      final response = await dio.post(
        '/api/Usuario/logout',
        data: {'refreshToken': refreshToken, 'fingerprint': fingerprint},
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

        final errorCodigo = data['errorCodigo'];
        if (errorCodigo != 'OK') {
          throw Exception(data['errorMensaje'] ?? 'Error desconocido');
        }

        final value = data['value'];
        return value == true;
      } else {
        throw Exception('Error al cerrar sesión: ${response.statusCode}');
      }
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> restaurarClave(
    String login,
    String numeroDocumento,
    String correoInstitucional,
  ) async {
    try {
      final response = await dio.put(
        '/api/Usuario/restaurarClave',
        data: {
          'login': login,
          'numeroDocumento': numeroDocumento,
          'correoInstitucional': correoInstitucional,
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
          return 'Respuesta vacía del servidor';
        }

        final errorCodigo = data['errorCodigo'];
        final errorMensaje = data['errorMensaje'] ?? 'Error desconocido';
        if (errorCodigo != 'OK') {
          return errorMensaje;
        }
        return errorMensaje;
      } else {
        final data = response.data;
        if (data != null && data['errorMensaje'] != null) {
          return data['errorMensaje'];
        } else {
          return 'Error al solicitar código de recuperación: ${response.statusCode}';
        }
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData != null && responseData is Map<String, dynamic>) {
        final errorMensaje = responseData['errorMensaje'];
        if (errorMensaje != null) {
          return errorMensaje;
        }
      }
      return 'Error en la solicitud: ${e.message}';
    } catch (e) {
      rethrow;
    }
  }
}
