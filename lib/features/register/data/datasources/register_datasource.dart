import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/app_exports.dart';

class RegisterDataSource {
  final Dio dio;

  RegisterDataSource({required this.dio});

  Future<String> enviarVerificacionOTP(String correo, String pcIp) async {
    try {
      final response = await dio.post(
        '/api/Usuario/enviarOTPRegistro',
        data: jsonEncode({'correo': correo, 'pcIp': pcIp}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );

      final Map<String, dynamic> jsonData = response.data is String
          ? jsonDecode(response.data as String)
          : response.data as Map<String, dynamic>;

      final errorCodigo = jsonData["errorCodigo"];
      final errorMensaje = jsonData["errorMensaje"] ?? "Error desconocido";

      if (response.statusCode == 200 && errorCodigo == "OK") {
        return errorMensaje;
      } else {
        throw Exception(errorMensaje);
      }
    } on DioException catch (e, stackTrace) {
      throw Exception('Error en la solicitud: ${e.message}\n$stackTrace');
    } catch (e) {
      throw Exception('Error al procesar la respuesta del servidor: $e');
    }
  }

  Future<String> enviarVerificacionCodigoOTP(
    String correo,
    String codigoOtp,
  ) async {
    try {
      final response = await dio.post(
        '/api/Usuario/verificarOTPRegistro',
        data: jsonEncode({'correo': correo, 'codigoOtp': codigoOtp}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );

      final Map<String, dynamic> jsonData = response.data is String
          ? jsonDecode(response.data as String)
          : response.data as Map<String, dynamic>;

      final errorCodigo = jsonData["errorCodigo"];
      final errorMensaje = jsonData["errorMensaje"] ?? "Error desconocido";

      if (response.statusCode == 200 && errorCodigo == "OK") {
        return errorMensaje;
      } else {
        throw Exception(errorMensaje);
      }
    } on DioException catch (e, stackTrace) {
      throw Exception('Error en la solicitud: ${e.message}\n$stackTrace');
    } catch (e) {
      throw Exception('Error al procesar la respuesta del servidor: $e');
    }
  }

  Future<String> registrarCuenta(
    RegisterState registerState,
    RegisterPinState pinState,
  ) async {
    try {
      final response = await dio.post(
        '/api/Usuario/registroCliente',
        data: jsonEncode({
          'tipoPersona': registerState.tipoPersona,
          'tipoDocumento': registerState.tipoDocumento,
          'numeroDocumento': registerState.numeroDocumento,
          'primerApellido': registerState.primerApellido,
          'segundoApellido': registerState.segundoApellido,
          'nombres': registerState.nombres,
          'fechaNacimiento': registerState.fechaNacimiento,
          'sexo': registerState.sexo,
          'correo': registerState.correo,
          'login': registerState.correo,
          'clave': registerState.contrasena,
          'pin': pinState.pin,
          'celular': registerState.celular,
          'rutaImagen1': registerState.rutaImagen1,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );

      final Map<String, dynamic> jsonData = response.data is String
          ? jsonDecode(response.data as String)
          : response.data as Map<String, dynamic>;

      final errorCodigo = jsonData["errorCodigo"];
      final errorMensaje = jsonData["errorMensaje"] ?? "Error desconocido";

      if (response.statusCode == 200 && errorCodigo == "OK") {
        return errorCodigo;
      } else {
        throw Exception(errorMensaje);
      }
    } on DioException catch (e, stackTrace) {
      throw Exception('Error en la solicitud: ${e.message}\n$stackTrace');
    } catch (e) {
      throw Exception('Error al procesar la respuesta del servidor: $e');
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
