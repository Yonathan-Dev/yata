import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_exports.dart';

class YatasListNotifier extends AsyncNotifier<List<YataModel>> {
  @override
  Future<List<YataModel>> build() async {
    final repository = ref.read(registrarRepositoryProvider);
    final usuario = ref.read(authProvider).user?.username ?? '';

    try {
      final yata = await repository.obteneryataOperador(usuario);
      if (yata != null) {
        return [yata];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> recargaryata() async {
    state = const AsyncValue.loading();
    final repository = ref.read(registrarRepositoryProvider);
    final usuario = ref.read(authProvider).user?.username ?? '';

    state = await AsyncValue.guard(() async {
      final yata = await repository.obteneryataOperador(usuario);
      if (yata != null) {
        return [yata];
      }
      return [];
    });
  }
}

final yatasListProvider =
    AsyncNotifierProvider<YatasListNotifier, List<YataModel>>(() {
      return YatasListNotifier();
    });

class YataSeleccionadoNotifier extends Notifier<YataModel?> {
  @override
  YataModel? build() {
    return null;
  }

  void seleccionaryata(YataModel yata) {
    state = yata;
  }

  void limpiarSeleccion() {
    state = null;
  }

  void actualizaryata(YataModel yata) {
    state = yata;
  }
}

final yataSeleccionadoProvider =
    NotifierProvider<YataSeleccionadoNotifier, YataModel?>(() {
      return YataSeleccionadoNotifier();
    });
