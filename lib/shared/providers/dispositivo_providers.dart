import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DispositivoState {
  final String plataforma;
  final String modelo;
  final String versionOs;
  final String ipAddress;
  final String userAgent;

  DispositivoState({
    this.plataforma = '',
    this.modelo = '',
    this.versionOs = '',
    this.ipAddress = '0.0.0.0',
    this.userAgent = '',
  });
  DispositivoState copyWith({
    String? plataforma,
    String? modelo,
    String? versionOs,
    String? ipAddress,
    String? userAgent,
  }) {
    return DispositivoState(
      plataforma: plataforma ?? this.plataforma,
      modelo: modelo ?? this.modelo,
      versionOs: versionOs ?? this.versionOs,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
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

  void setIpAddress(String value) {
    state = state.copyWith(ipAddress: value);
  }

  void setUserAgent(String value) {
    state = state.copyWith(userAgent: value);
  }

  void setDispositivo({
    required String plataforma,
    required String modelo,
    required String versionOs,
    required String ipAddress,
    required String userAgent,
  }) {
    state = state.copyWith(
      plataforma: plataforma,
      modelo: modelo,
      versionOs: versionOs,
      ipAddress: ipAddress,
      userAgent: userAgent,
    );
  }

  void resetEstado() {
    state = DispositivoState();
  }

  Future<void> obtenerInfoDispositivo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String appName = 'BilleteraPay';
    String appVersion = '1.0.0';

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setPlataforma('Android ${androidInfo.brand} ${androidInfo.model}');
      setVersionOs('Android ${androidInfo.version.release}');
      setModelo('${androidInfo.brand} ${androidInfo.model}');
      setUserAgent('$appName Android/$appVersion');
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setPlataforma('iOS ${iosInfo.model} ${iosInfo.systemVersion}');
      setVersionOs('iOS ${iosInfo.systemVersion}');
      setModelo(iosInfo.model);
      setUserAgent('$appName iOS/$appVersion}');
    }
  }
}

final dispositivoProvider =
    NotifierProvider<DispositivoNotifier, DispositivoState>(
      () => DispositivoNotifier(),
    );
