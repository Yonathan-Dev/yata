import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DispositivoState {
  final String plataforma;
  final String modelo;
  final String versionOs;
  final String ipAddress;
  final String userAgent;
  final String versionApp;
  final String buildApp;

  DispositivoState({
    this.plataforma = '',
    this.modelo = '',
    this.versionOs = '',
    this.ipAddress = '0.0.0.0',
    this.userAgent = '',
    this.versionApp = '1.0.0',
    this.buildApp = '1',
  });
  DispositivoState copyWith({
    String? plataforma,
    String? modelo,
    String? versionOs,
    String? ipAddress,
    String? userAgent,
    String? versionApp,
    String? buildApp,
  }) {
    return DispositivoState(
      plataforma: plataforma ?? this.plataforma,
      modelo: modelo ?? this.modelo,
      versionOs: versionOs ?? this.versionOs,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      versionApp: versionApp ?? this.versionApp,
      buildApp: buildApp ?? this.buildApp,
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

  void setVersionApp(String value) {
    state = state.copyWith(versionApp: value);
  }

  void setBuildApp(String value) {
    state = state.copyWith(buildApp: value);
  }

  void setDispositivo({
    required String plataforma,
    required String modelo,
    required String versionOs,
    required String ipAddress,
    required String userAgent,
    required String versionApp,
    required String buildApp,
  }) {
    state = state.copyWith(
      plataforma: plataforma,
      modelo: modelo,
      versionOs: versionOs,
      ipAddress: ipAddress,
      userAgent: userAgent,
      versionApp: versionApp,
      buildApp: buildApp,
    );
  }

  void resetEstado() {
    state = DispositivoState();
  }

  Future<void> obtenerInfoDispositivo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String appName = 'BilleteraPay';
    String appVersion = state.versionApp;

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

  Future<void> obtenerVersionApp() async {
    final info = await PackageInfo.fromPlatform();
    setVersionApp(info.version);
    setBuildApp(info.buildNumber);
  }
}

final dispositivoProvider =
    NotifierProvider<DispositivoNotifier, DispositivoState>(
      () => DispositivoNotifier(),
    );
