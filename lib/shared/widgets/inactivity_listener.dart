import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/inactivity_provider.dart';

class InactivityListener extends ConsumerWidget {
  final Widget child;
  const InactivityListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => ref.read(inactivityProvider.notifier).resetTimer(),
      onPointerMove: (_) => ref.read(inactivityProvider.notifier).resetTimer(),
      onPointerUp: (_) => ref.read(inactivityProvider.notifier).resetTimer(),
      child: child,
    );
  }
}
