// inactivity_provider.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_exports.dart';

const _kInactivityLimit = Duration(minutes: 5);

class InactivityNotifier extends Notifier<void> {
  Timer? _timer;

  @override
  void build() {
    _startTimer();
    ref.onDispose(() => _timer?.cancel());
  }

  void resetTimer() {
    _timer?.cancel();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(_kInactivityLimit, _onTimeout);
  }

  void _onTimeout() async {
    ref.invalidate(logoutProvider);
    await ref.read(logoutProvider.future);
    ref.read(authProvider.notifier).logout();
  }
}

final inactivityProvider = NotifierProvider<InactivityNotifier, void>(
  InactivityNotifier.new,
);
