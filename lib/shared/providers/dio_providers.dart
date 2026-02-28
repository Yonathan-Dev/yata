import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../interceptors/dio_interceptor.dart';

final dioYataProvider = Provider<Dio>((ref) {
  final apiYate = dotenv.env['BASE_URL'] ?? '';

  final dio = Dio(
    BaseOptions(
      baseUrl: apiYate,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  dio.interceptors.add(DioInterceptor());

  return dio;
});
