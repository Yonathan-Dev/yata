import 'package:flutter_riverpod/legacy.dart';

// Provider para manejar el índice de navegación
final navigationIndexProvider = StateProvider<int>((ref) => 0);
