import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioAuthInterceptor extends Interceptor {
  final Dio dio;
  final _secureStorage = const FlutterSecureStorage();
  final String refreshEndpoint;
  final VoidCallback? onSessionExpired;

  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  DioAuthInterceptor({
    required this.dio,
    this.refreshEndpoint = '/api/Usuario/refresh-token',
    this.onSessionExpired,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path != refreshEndpoint) {
      final accessToken = await _secureStorage.read(key: 'accessToken');
      final expiresAtRaw = await _secureStorage.read(key: 'expiresAt');

      if (accessToken != null) {
        final expiresAt = expiresAtRaw != null
            ? DateTime.tryParse(expiresAtRaw)
            : null;
        final isAboutToExpire =
            expiresAt != null &&
            expiresAt.isBefore(DateTime.now().add(const Duration(seconds: 60)));

        if (isAboutToExpire) {
          final refreshed = await _tryRefreshToken();
          if (refreshed) {
            final newToken = await _secureStorage.read(key: 'accessToken');
            final tokenType =
                await _secureStorage.read(key: 'tokenType') ?? 'Bearer';
            options.headers['Authorization'] = '$tokenType $newToken';
          }
        } else {
          final tokenType =
              await _secureStorage.read(key: 'tokenType') ?? 'Bearer';
          options.headers['Authorization'] = '$tokenType $accessToken';
        }
      }
    }

    _logRequest(options);
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      'Response (${response.statusCode}): '
      '${const JsonEncoder.withIndent('  ').convert(response.data)}',
    );
    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != refreshEndpoint) {
      if (_isRefreshing) {
        _pendingRequests.add(_PendingRequest(err.requestOptions, handler));
        return;
      }

      _isRefreshing = true;
      final refreshed = await _tryRefreshToken();
      _isRefreshing = false;

      if (refreshed) {
        final newToken = await _secureStorage.read(key: 'accessToken');
        final tokenType =
            await _secureStorage.read(key: 'tokenType') ?? 'Bearer';
        err.requestOptions.headers['Authorization'] = '$tokenType $newToken';

        for (final pending in _pendingRequests) {
          pending.options.headers['Authorization'] = '$tokenType $newToken';
          _retryRequest(pending.options, pending.handler);
        }
        _pendingRequests.clear();
        return _retryRequest(err.requestOptions, handler);
      } else {
        //await _secureStorage.deleteAll();
        _pendingRequests.clear();
        onSessionExpired?.call();
      }
    }

    return handler.reject(_buildDioException(err, _extractErrorMessage(err)));
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refreshToken');
      final fingerprint = await _secureStorage.read(key: 'fingerprint');
      if (refreshToken == null || fingerprint == null) return false;

      final response = await dio.post(
        refreshEndpoint,
        data: {'refreshToken': refreshToken, 'fingerprint': fingerprint},
      );

      final data = response.data as Map<String, dynamic>;
      final value = data['value'] as Map<String, dynamic>;
      await _secureStorage.write(
        key: 'accessToken',
        value: value['accessToken'],
      );
      await _secureStorage.write(
        key: 'refreshToken',
        value: value['refreshToken'],
      );
      await _secureStorage.write(key: 'expiresAt', value: value['expiresAt']);
      await _secureStorage.write(key: 'tokenType', value: value['tokenType']);

      log('Token refrescado exitosamente');
      return true;
    } catch (e) {
      log('Error al refrescar token: $e');
      return false;
    }
  }

  Future<void> _retryRequest(
    RequestOptions options,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      handler.resolve(await dio.fetch(options));
    } catch (e) {
      handler.reject(e as DioException);
    }
  }

  void _logRequest(RequestOptions options) {
    log('${options.method}: ${options.baseUrl}${options.path}');
    log(
      'Cabecera: ${const JsonEncoder.withIndent('  ').convert(options.headers)}',
    );
    log(
      'Parametros: ${const JsonEncoder.withIndent('  ').convert(options.data)}',
    );
    log(
      'Query: ${const JsonEncoder.withIndent('  ').convert(options.queryParameters)}',
    );
  }

  String _extractErrorMessage(DioException err) {
    final statusCode = err.response?.statusCode;
    final responseData = err.response?.data;

    if (responseData is Map<String, dynamic>) {
      log(
        'Error Response: ${const JsonEncoder.withIndent('  ').convert(responseData)}',
      );
      if (responseData['error'] is Map<String, dynamic>) {
        final e = responseData['error'] as Map<String, dynamic>;
        return e['message'] ?? e['header'] ?? 'Error desconocido';
      }
      return responseData['errorMensaje'] ??
          responseData['message'] ??
          responseData['error'] ??
          responseData['vDesc'] ??
          responseData['msg'] ??
          responseData['mensaje'] ??
          'Error del servidor (Status: $statusCode)';
    }
    if (responseData is String && responseData.isNotEmpty) return responseData;
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return 'Tiempo de espera agotado. Verifique su conexión.';
    }
    if (err.type == DioExceptionType.connectionError) {
      return 'Error de conexión. Verifique su red.';
    }
    return err.message ?? 'Error desconocido';
  }

  DioException _buildDioException(DioException original, String message) =>
      DioException(
        requestOptions: original.requestOptions,
        response: original.response,
        type: original.type,
        error: message,
        message: message,
      );
}

class _PendingRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;
  _PendingRequest(this.options, this.handler);
}
