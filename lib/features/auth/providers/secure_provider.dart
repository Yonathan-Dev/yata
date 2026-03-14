import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

final fingerPrintProvider = FutureProvider<String>((ref) async {
  final fingerprint = await ref.read(fingerprintCryptoProvider.future);
  return fingerprint;
});

final verificationTokenProvider = FutureProvider<String?>((ref) async {
  final token = await secureStorage.read(key: 'verificationToken');
  return token ?? '';
});

final refreshTokenProvider = FutureProvider<String?>((ref) async {
  final token = await secureStorage.read(key: 'refreshToken');
  return token ?? '';
});

final accessTokenProvider = FutureProvider<String?>((ref) async {
  final token = await secureStorage.read(key: 'accessToken');
  return token ?? '';
});
