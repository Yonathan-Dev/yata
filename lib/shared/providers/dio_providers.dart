import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/app_exports.dart';
import '../shared_exports.dart';

final dioYataProvider = Provider<Dio>((ref) {
  final apiYata = dotenv.env['BASE_URL'] ?? '';

  final dio = Dio(
    BaseOptions(
      baseUrl: apiYata,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  dio.interceptors.add(DioInterceptor());

  return dio;
});

final dioYataAuthProvider = Provider<Dio>((ref) {
  final apiYata = dotenv.env['BASE_URL'] ?? '';
  final publicDio = ref.read(dioYataProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: apiYata,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  dio.interceptors.add(
    DioAuthInterceptor(
      dio: publicDio,
      refreshEndpoint: '/api/Usuario/refresh-token',
      onSessionExpired: () async {
        final authNotifier = ref.read(authProvider.notifier);
        authNotifier.setLoading(isLoading: true, mensaje: 'Cerrando sesión...');
        try {
          ref.invalidate(logoutProvider);
          await ref.read(logoutProvider.future);
          await authNotifier.logout();
        } catch (e) {
          //SnackbarUtil.snackbarError(context, message: e.toString());
        } finally {
          authNotifier.setLoading(isLoading: false, mensaje: '');
        }
      },
    ),
  );

  return dio;
});
