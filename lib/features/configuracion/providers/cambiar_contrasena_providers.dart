import 'package:flutter_riverpod/legacy.dart';

final filledFieldsProvider = StateProvider<List<bool>>((ref) {
  return List.generate(6, (_) => false);
});

final showActualPasswordProvider = StateProvider<bool>((ref) => false);
final showNuevaPasswordProvider = StateProvider<bool>((ref) => false);
final showConfirmPasswordProvider = StateProvider<bool>((ref) => false);
