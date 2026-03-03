import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yate/core/app_exports.dart';

import '../../../shared/shared_exports.dart';

//Provider para Login
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final dio = ref.read(dioYataProvider);
  return AuthDataSource(dio: dio);
});
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.read(authDataSourceProvider);
  return AuthRepository(dataSource: dataSource);
});

final loginPinProvider = FutureProvider<AuthModel>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  final state = ref.watch(registerProvider);
  final pinState = ref.watch(pinProvider);
  final fingerprintState = await ref.watch(fingerPrintProvider.future);
  return await repository.postAuthPin(state.correo, pinState, fingerprintState);
});

final pinProvider = StateProvider<String>((ref) => '');
