import 'package:flutter_riverpod/legacy.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);
final navigationBarExpandedProvider = StateProvider<bool>((ref) => false);
