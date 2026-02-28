import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DispositivoState {
  final String plataforma;
  final String modelo;
  final String versionOs;

  DispositivoState({
    this.plataforma = '',
    this.modelo = '',
    this.versionOs = '',
  });
  DispositivoState copyWith({
    String? plataforma,
    String? modelo,
    String? versionOs,
  }) {
    return DispositivoState(
      plataforma: plataforma ?? this.plataforma,
      modelo: modelo ?? this.modelo,
      versionOs: versionOs ?? this.versionOs,
    );
  }
}

class DispositivoNotifier extends Notifier<DispositivoState> {
  @override
  DispositivoState build() {
    return DispositivoState();
  }

  void setPlataforma(String value) {
    state = state.copyWith(plataforma: value);
  }

  void setModelo(String value) {
    state = state.copyWith(modelo: value);
  }

  void setVersionOs(String value) {
    state = state.copyWith(versionOs: value);
  }

  void setDispositivo({
    required String plataforma,
    required String modelo,
    required String versionOs,
  }) {
    state = state.copyWith(
      plataforma: plataforma,
      modelo: modelo,
      versionOs: versionOs,
    );
  }

  void resetEstado() {
    state = DispositivoState();
  }

  Future<void> obtenerInfoDispositivo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setPlataforma('Android ${androidInfo.brand} ${androidInfo.model}');
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setPlataforma('iOS ${iosInfo.model} ${iosInfo.systemVersion} ');
    }
  }
}

final dispositivoProvider =
    NotifierProvider<DispositivoNotifier, DispositivoState>(
      () => DispositivoNotifier(),
    );
