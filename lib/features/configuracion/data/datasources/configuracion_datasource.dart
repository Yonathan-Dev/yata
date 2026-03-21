import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/app_exports.dart';

class ConfiguracionDataSource {
  final Dio dio;

  ConfiguracionDataSource({required this.dio});

  Future<PerfilModel> obtenerPerfil(int idUsuario) async {
    try {
      final response = await dio.get(
        '/api/Usuario/perfilCompleto/$idUsuario',
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

        return PerfilModel.fromJson(value);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> modificarPerfil(
    int idUsuario,
    int idTipoPersona,
    int idTipoDocumento,
    String numeroDocumento,
    String primerApellido,
    String segundoApellido,
    String nombres,
    String fechaNacimiento,
    bool sexo,
    String correo,
    String celular,
  ) async {
    try {
      final response = await dio.put(
        '/api/Usuario/modificaPerfilCli',
        data: {
          'idPersona': idUsuario,
          'idTipoPersona': idTipoPersona,
          'idTipoDocumento': idTipoDocumento,
          'numeroDocumento': numeroDocumento,
          'primerApellido': primerApellido,
          'segundoApellido': segundoApellido,
          'nombres': nombres,
          'fechaNacimiento': fechaNacimiento,
          'sexo': sexo,
          'correo': correo,
          'celular': celular,
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
        return 'Perfil modificado exitosamente';
      } else {
        final data = response.data;
        if (data != null && data['errorMensaje'] != null) {
          return data['errorMensaje'];
        } else {
          return 'Error al modificar el perfil: ${response.statusCode}';
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

  Future<String> solicitarCodigoOtp(int idUsuario, String login) async {
    try {
      final response = await dio.post(
        '/api/Usuario/solicitarCodigoCambioClave',
        data: {'idUsuario': idUsuario, 'login': login},
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
        final errorMensaje = data['errorMensaje'] ?? 'Error desconocido';
        if (errorCodigo != 'OK') {
          throw Exception(errorMensaje);
        }
        return data['value'];
      } else {
        throw Exception(
          'Error al solicitar código de cambio de contraseña: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData != null && responseData is Map<String, dynamic>) {
        final errorMensaje = responseData['errorMensaje'];
        if (errorMensaje != null) {
          throw Exception(errorMensaje);
        }
      }
      throw Exception('Error en la solicitud: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  Future<String> solicitarCodigoOtpPin(int idUsuario, String login) async {
    try {
      final response = await dio.post(
        '/api/Usuario/solicitarCodigoCambioPin',
        data: {'idUsuario': idUsuario, 'login': login},
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
        final errorMensaje = data['errorMensaje'] ?? 'Error desconocido';
        if (errorCodigo != 'OK') {
          throw Exception(errorMensaje);
        }
        return data['value'];
      } else {
        throw Exception(
          'Error al solicitar código de cambio de contraseña: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData != null && responseData is Map<String, dynamic>) {
        final errorMensaje = responseData['errorMensaje'];
        if (errorMensaje != null) {
          throw Exception(errorMensaje);
        }
      }
      throw Exception('Error en la solicitud: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  Future<String> enviarVerificacionCodigoOTP(
    String correo,
    String codigoOtp,
  ) async {
    try {
      final response = await dio.post(
        '/api/Usuario/verificarOTPRegistro',
        data: {'correo': correo, 'codigo': codigoOtp},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data is String
            ? jsonDecode(response.data as String)
            : response.data as Map<String, dynamic>;

        if (data == null) {
          throw Exception('Respuesta vacía del servidor');
        }

        final errorCodigo = data['errorCodigo'];
        final errorMensaje = data['errorMensaje'] ?? 'Error desconocido';
        if (errorCodigo != 'OK') {
          throw Exception(errorMensaje);
        }
        return errorMensaje;
      } else {
        throw Exception(
          'Error al verificar el código OTP: ${response.statusCode}',
        );
      }
    } on DioException catch (e, stackTrace) {
      throw Exception('Error en la solicitud: ${e.message}\n$stackTrace');
    } catch (e) {
      throw Exception('Error al procesar la respuesta del servidor: $e');
    }
  }

  Future<String> solicitarCambioConstrasena(
    int idUsuario,
    String login,
    String passwordAnterior,
    String claveNueva,
    String codigoOtp,
  ) async {
    try {
      final response = await dio.put(
        '/api/Usuario/cambiarClave',
        data: {
          'idUsuario': idUsuario,
          'login': login,
          'claveAnterior': passwordAnterior,
          'claveNueva': claveNueva,
          'codigoOTP': codigoOtp,
          'idUsuarioLogin': idUsuario,
          'pcIp': '0.0.0.0',
          'pcHost': 'mobile',
        },
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(milliseconds: 30000),
          receiveTimeout: Duration(milliseconds: 30000),
        ),
      );

      final data = response.data;
      if (response.statusCode == 200) {
        if (data == null) {
          return 'Respuesta vacía del servidor';
        }
        final errorCodigo = data['errorCodigo'];
        final errorMensaje = data['errorMensaje'] ?? 'Error desconocido';
        if (errorCodigo != 'OK') {
          return errorMensaje;
        }
        return 'Contraseña cambiada exitosamente';
      } else {
        return 'Error al cambiar la contraseña: ${response.statusCode}';
      }
    } on DioException catch (e) {
      return e.message ?? 'Error en la solicitud';
    } catch (e) {
      rethrow;
    }
  }

  Future<String> solicitarCambioPin(
    int idUsuario,
    String login,
    String pinActual,
    String pinNuevo,
    String codigoOtp,
  ) async {
    try {
      final response = await dio.post(
        '/api/Usuario/cambiarPin',
        data: {
          'idUsuario': idUsuario,
          'login': login,
          'pinActual': pinActual,
          'pinNuevo': pinNuevo,
          'codigoOTP': codigoOtp,
          'idUsuarioLogin': idUsuario,
          'pcIp': '0.0.0.0',
          'pcHost': 'mobile',
        },
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: Duration(milliseconds: 30000),
          receiveTimeout: Duration(milliseconds: 30000),
        ),
      );

      final data = response.data;
      if (response.statusCode == 200) {
        if (data == null) {
          return 'Respuesta vacía del servidor';
        }
        final errorCodigo = data['errorCodigo'];
        final errorMensaje = data['errorMensaje'] ?? 'Error desconocido';
        if (errorCodigo != 'OK') {
          return errorMensaje;
        }
        return 'Contraseña cambiada exitosamente';
      } else {
        return 'Error al cambiar la contraseña: ${response.statusCode}';
      }
    } on DioException catch (e) {
      return e.message ?? 'Error en la solicitud';
    } catch (e) {
      rethrow;
    }
  }
}
