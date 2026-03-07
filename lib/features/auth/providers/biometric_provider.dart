import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:yate/core/secure.dart';

class BiometricState {
  final bool isAuthenticating;
  final bool isSupported;
  final bool isEnabled;
  final String? error;
  final String? correo;
  final String? pin;

  const BiometricState({
    this.isAuthenticating = false,
    this.isSupported = false,
    this.isEnabled = false,
    this.error,
    this.correo,
    this.pin,
  });

  BiometricState copyWith({
    bool? isAuthenticating,
    bool? isSupported,
    bool? isEnabled,
    String? error,
    String? correo,
    String? pin,
  }) {
    return BiometricState(
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      isSupported: isSupported ?? this.isSupported,
      isEnabled: isEnabled ?? this.isEnabled,
      error: error,
      correo: correo ?? this.correo,
      pin: pin ?? this.pin,
    );
  }
}

class BiometricNotifier extends StateNotifier<BiometricState> {
  final LocalAuthentication _auth;

  BiometricNotifier(this._auth) : super(const BiometricState()) {
    _init();
  }

  Future<void> _init() async {
    await _checkSupport();
    await _checkIfEnabled();
  }

  Future<void> _checkSupport() async {
    try {
      final isSupported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      state = state.copyWith(isSupported: isSupported && canCheck);
    } catch (e) {
      state = state.copyWith(isSupported: false);
    }
  }

  Future<void> _checkIfEnabled() async {
    final biometricEnabled = await secureStorage.read(key: 'biometricEnabled');
    final correo = await secureStorage.read(key: 'userCorreo');
    final pin = await secureStorage.read(key: 'pin');

    state = state.copyWith(
      isEnabled: biometricEnabled == 'true' && correo != null && pin != null,
      correo: correo,
      pin: pin,
    );
  }

  bool get canUseBiometric => state.isSupported && state.isEnabled;

  Future<({bool success, String? correo, String? pin})>
  autenticarYObtenerCredenciales() async {
    await _checkSupport();
    await _checkIfEnabled();

    if (!state.isSupported) {
      state = state.copyWith(
        error: 'Tu dispositivo no soporta autenticación biométrica',
      );
      return (success: false, correo: null, pin: null);
    }

    if (!state.isEnabled) {
      state = state.copyWith(
        error: 'Primero ingresa con tu PIN para activar la huella',
      );
      return (success: false, correo: null, pin: null);
    }

    try {
      state = state.copyWith(isAuthenticating: true, error: null);

      final bool autenticado = await _auth.authenticate(
        localizedReason: 'Ingresa con tu huella dactilar',
        persistAcrossBackgrounding: true,
        biometricOnly: true,
      );

      state = state.copyWith(isAuthenticating: false);

      if (autenticado) {
        return (success: true, correo: state.correo, pin: state.pin);
      }

      return (success: false, correo: null, pin: null);
    } on LocalAuthException catch (e) {
      state = state.copyWith(
        isAuthenticating: false,
        error:
            e.code != LocalAuthExceptionCode.userCanceled &&
                e.code != LocalAuthExceptionCode.systemCanceled
            ? e.description
            : null,
      );
      return (success: false, correo: null, pin: null);
    } on PlatformException catch (e) {
      state = state.copyWith(isAuthenticating: false, error: e.message);
      return (success: false, correo: null, pin: null);
    } catch (e) {
      state = state.copyWith(
        isAuthenticating: false,
        error: 'Error al autenticar',
      );
      return (success: false, correo: null, pin: null);
    }
  }

  Future<void> habilitarBiometrico(String correo, String pin) async {
    await secureStorage.write(key: 'biometricEnabled', value: 'true');
    await secureStorage.write(key: 'userCorreo', value: correo);
    await secureStorage.write(key: 'pin', value: pin);
    state = state.copyWith(isEnabled: true, correo: correo, pin: pin);
  }

  Future<void> deshabilitarBiometrico() async {
    await secureStorage.delete(key: 'biometricEnabled');
    await secureStorage.delete(key: 'pin');
    state = state.copyWith(isEnabled: false, pin: null);
  }

  Future<void> cancelar() async {
    await _auth.stopAuthentication();
    state = state.copyWith(isAuthenticating: false);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> refresh() async {
    await _init();
  }
}

final localAuthProvider = Provider((ref) => LocalAuthentication());
final biometricProvider =
    StateNotifierProvider<BiometricNotifier, BiometricState>(
      (ref) => BiometricNotifier(ref.read(localAuthProvider)),
    );
