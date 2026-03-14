import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  //Antes de la petición
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    String cabeceraJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(options.headers);
    String parametroJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(options.data);
    String queryJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(options.queryParameters);

    log("${options.method}: $requestPath");
    log("Cabecera: $cabeceraJson");
    log("Parametros: $parametroJson");
    log("Query: $queryJson");

    return super.onRequest(options, handler);
  }

  //Después de la respuesta
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    String respuestaJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(response.data);
    log('Response (${response.statusCode}): $respuestaJson');
    return super.onResponse(response, handler);
  }

  //cuando hay un error
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    log('${options.method} request => $requestPath');

    String errorMessage = err.message ?? 'Error desconocido';

    // Extraer el mensaje de error del servidor
    if (err.response != null) {
      final responseData = err.response?.data;
      final statusCode = err.response?.statusCode;

      log('Error Status Code: $statusCode');

      // Si la respuesta tiene datos estructurados
      if (responseData is Map<String, dynamic>) {
        String dataJson = const JsonEncoder.withIndent(
          '  ',
        ).convert(responseData);
        log('Error Response Data: $dataJson');

        // Extraer mensaje de error de campos comunes
        if (responseData['error'] != null &&
            responseData['error'] is Map<String, dynamic>) {
          final errorMap = responseData['error'] as Map<String, dynamic>;
          errorMessage =
              errorMap['message'] ?? errorMap['header'] ?? 'Error desconocido';
        } else {
          errorMessage =
              responseData['errorMensaje'] ??
              responseData['message'] ??
              responseData['error'] ??
              responseData['vDesc'] ??
              responseData['msg'] ??
              responseData['mensaje'] ??
              'Error del servidor (Status: $statusCode)';
        }
      }
      // Si es una respuesta de texto plano
      else if (responseData is String && responseData.isNotEmpty) {
        log('Error Response Data: $responseData');
        errorMessage = responseData;
      } else {
        log('Error: ${err.error}, Message: ${err.message}');
        errorMessage = 'Error del servidor (Status: $statusCode)';
      }
    }
    // Errores de timeout
    else if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      log('Error: Timeout - ${err.type}');
      errorMessage = 'Tiempo de espera agotado. Verifique su conexión.';
    }
    // Errores de conexión
    else if (err.type == DioExceptionType.connectionError) {
      log('Error: Connection Error');
      errorMessage = 'Error de conexión. Verifique su red.';
    } else {
      log('Error: ${err.error}, Message: ${err.message}');
    }

    // Crear una nueva excepción con el mensaje mejorado
    final newError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: errorMessage,
      message: errorMessage,
    );

    return handler.reject(newError);
  }
}
