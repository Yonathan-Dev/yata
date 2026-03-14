import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

// Estado de recuperación de contraseña
class ForgotState {
  final String passwordTemporal;
  final String passwordNueva;
  final String codigoOtp;
  final bool isLoading;
  final String? error;
  final String mensaje;

  const ForgotState({
    this.passwordTemporal = '',
    this.passwordNueva = '',
    this.codigoOtp = '',
    this.isLoading = false,
    this.error,
    this.mensaje = '',
  });

  ForgotState copyWith({
    String? passwordTemporal,
    String? passwordNueva,
    String? codigoOtp,
    bool? isLoading,
    String? error,
    String? mensaje,
  }) {
    return ForgotState(
      passwordTemporal: passwordTemporal ?? this.passwordTemporal,
      passwordNueva: passwordNueva ?? this.passwordNueva,
      codigoOtp: codigoOtp ?? this.codigoOtp,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      mensaje: mensaje ?? this.mensaje,
    );
  }
}

// Notifier para manejar la recuperación de contraseña
class ForgotNotifier extends Notifier<ForgotState> {
  @override
  ForgotState build() {
    return const ForgotState();
  }

  void setPasswordTemporal(String value) {
    state = state.copyWith(passwordTemporal: value);
  }

  void setPasswordNueva(String value) {
    state = state.copyWith(passwordNueva: value);
  }

  void setCodigoOtp(String value) {
    state = state.copyWith(codigoOtp: value);
  }

  void setLoading({required bool isLoading, String mensaje = ''}) {
    state = state.copyWith(isLoading: isLoading, mensaje: mensaje);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void resetearEstado() {
    state = const ForgotState();
  }
}

final forgotProvider = NotifierProvider<ForgotNotifier, ForgotState>(
  () => ForgotNotifier(),
);

//Provider para Login
final forgotDataSourceProvider = Provider<AuthDataSource>((ref) {
  final dio = ref.read(dioYataProvider);
  return AuthDataSource(dio: dio);
});
final forgotRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.read(forgotDataSourceProvider);
  return AuthRepository(dataSource: dataSource);
});

final cambiarClaveProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(forgotRepositoryProvider);
  final authState = ref.watch(authProvider);
  final forgotState = ref.watch(forgotProvider);
  final idUsuario = authState.idUsuario;
  final login = authState.login;
  final passwordTemporal = forgotState.passwordTemporal;
  final claveNueva = forgotState.passwordNueva;
  final codigoOtp = forgotState.codigoOtp;
  return await repository.cambiarClave(
    idUsuario,
    login,
    passwordTemporal,
    claveNueva,
    codigoOtp,
  );
});

final solicitoCambioClaveProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(forgotRepositoryProvider);
  final authState = ref.watch(authProvider);
  final idUsuario = authState.idUsuario;
  final login = authState.login;
  return await repository.solicitarCambioClave(idUsuario, login);
});

final obscureCurrentPasswordProvider = StateProvider<bool>((ref) => true);
final obscureNewPasswordProvider = StateProvider<bool>((ref) => true);
final obscureConfirmPasswordProvider = StateProvider<bool>((ref) => true);
