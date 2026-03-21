import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

//estado para cambiar PIN
class CambiarPinState {
  final String correo;
  final String codigoOtp;
  final String pinActual;
  final String pinNuevo;
  final String confirmarPinNuevo;
  final bool isLoading;
  final String mensaje;
  final String? error;

  CambiarPinState({
    this.correo = '',
    this.codigoOtp = '',
    this.pinActual = '',
    this.pinNuevo = '',
    this.confirmarPinNuevo = '',
    this.isLoading = false,
    this.mensaje = '',
    this.error,
  });

  CambiarPinState copyWith({
    String? correo,
    String? codigoOtp,
    String? pinActual,
    String? pinNuevo,
    String? confirmarPinNuevo,
    bool? isLoading,
    String? mensaje,
    String? error,
  }) {
    return CambiarPinState(
      correo: correo ?? this.correo,
      codigoOtp: codigoOtp ?? this.codigoOtp,
      pinActual: pinActual ?? this.pinActual,
      pinNuevo: pinNuevo ?? this.pinNuevo,
      confirmarPinNuevo: confirmarPinNuevo ?? this.confirmarPinNuevo,
      isLoading: isLoading ?? this.isLoading,
      mensaje: mensaje ?? this.mensaje,
      error: error ?? this.error,
    );
  }
}

class CambiarPinNotifier extends StateNotifier<CambiarPinState> {
  CambiarPinNotifier() : super(CambiarPinState());

  void setCorreo(String correo) {
    state = state.copyWith(correo: correo);
  }

  void setCodigoOtp(String codigo) {
    state = state.copyWith(codigoOtp: codigo);
  }

  void setPinActual(String pin) {
    state = state.copyWith(pinActual: pin);
  }

  void setPinNuevo(String pin) {
    state = state.copyWith(pinNuevo: pin);
  }

  void setConfirmarPinNuevo(String pin) {
    state = state.copyWith(confirmarPinNuevo: pin);
  }

  void setIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setMensaje(String mensaje) {
    state = state.copyWith(mensaje: mensaje);
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }

  void resetEstado() {
    state = CambiarPinState();
  }

  String? validarCampo(String value, String campo) {
    if (value.isEmpty || value == 'null') {
      return 'El campo $campo es obligatorio';
    }
    if (value.length < 6) {
      return 'Mínimo 6 caracteres';
    }
    return null;
  }

  //enviar a auth provider para cerrar sesión
  Future<void> logout() async {
    try {
      await secureStorage.delete(key: 'accessToken');
      await secureStorage.delete(key: 'refreshToken');
      await secureStorage.delete(key: 'verificationToken');
      await secureStorage.delete(key: 'expiresAt');
      await secureStorage.delete(key: 'tokenType');
      await secureStorage.delete(key: 'userName');
      await secureStorage.delete(key: 'passwordTemporary');

      navigatorKey.currentContext?.go('/pin');
      state = CambiarPinState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        mensaje: '',
      );
    }
  }

  void capturarDatos({
    required String correo,
    required String codigoOtp,
    required String pinActual,
    required String pinNuevo,
    required String confirmarPinNuevo,
  }) {
    state = state.copyWith(
      correo: correo,
      codigoOtp: codigoOtp,
      pinActual: pinActual,
      pinNuevo: pinNuevo,
      confirmarPinNuevo: confirmarPinNuevo,
    );
  }
}

final cambiarPinProvider =
    StateNotifierProvider<CambiarPinNotifier, CambiarPinState>(
      (ref) => CambiarPinNotifier(),
    );

final cambiarPinDataSourceProvider = Provider<ConfiguracionDataSource>((ref) {
  final dio = ref.read(dioYataAuthProvider);
  return ConfiguracionDataSource(dio: dio);
});

final cambiarPinRepositoryProvider = Provider<ConfiguracionRepository>((ref) {
  final dataSource = ref.read(cambiarPinDataSourceProvider);
  return ConfiguracionRepository(dataSource: dataSource);
});

final solicitarCodigoOtpPinProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(cambiarPinRepositoryProvider);
  final idUsuario = ref.watch(authProvider).user?.idUsuario ?? 0;
  final login = ref.watch(authProvider).user?.login ?? '';
  return await repository.solicitarCodigoOtpPin(idUsuario, login);
});

final solicitarCambioPinProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(cambiarPinRepositoryProvider);
  final idUsuario = ref.watch(authProvider).user?.idUsuario ?? 0;
  final login = ref.watch(cambiarPinProvider).correo;
  final pinActual = ref.watch(cambiarPinProvider).pinActual;
  final pinNuevo = ref.watch(cambiarPinProvider).pinNuevo;
  final codigoOtp = ref.watch(cambiarPinProvider).codigoOtp;
  return await repository.solicitarCambioPin(
    idUsuario,
    login,
    pinActual,
    pinNuevo,
    codigoOtp,
  );
});
