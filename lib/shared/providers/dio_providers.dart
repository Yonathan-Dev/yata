import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../interceptors/dio_interceptor.dart';

final dioSeguridadProvider = Provider<Dio>((ref) {
  final apiSeguridad = dotenv.env['BASE_URL'] ?? '';

  final dio = Dio(
    BaseOptions(
      baseUrl: apiSeguridad,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(DioInterceptor());

  return dio;
});

final dioEmergenciasProvider = Provider<Dio>((ref) {
  final apiEmergencias = dotenv.env['BASE_URL'] ?? '';

  final dio = Dio(
    BaseOptions(
      baseUrl: apiEmergencias,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  dio.interceptors.add(DioInterceptor());

  return dio;
});
