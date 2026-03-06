import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_exports.dart';

final fingerPrintProvider = FutureProvider<String>((ref) async {
  final fingerPrint = await secureStorage.read(key: 'fingerprint');
  return fingerPrint ?? '';
});

final verificationTokenProvider = FutureProvider<String?>((ref) async {
  final token = await secureStorage.read(key: 'verificationToken');
  return token;
});
