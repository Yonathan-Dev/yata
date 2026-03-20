import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

// Estado de autenticación
class AuthState {
  final int idUsuario;
  final String login;
  final String password;
  final String numeroDocumento;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final String mensaje;
  final User? user;

  const AuthState({
    this.idUsuario = 0,
    this.login = '',
    this.password = '',
    this.numeroDocumento = '',
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.mensaje = '',
    this.user,
  });

  AuthState copyWith({
    int? idUsuario,
    String? login,
    String? password,
    String? numeroDocumento,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    String? mensaje,
    User? user,
  }) {
    return AuthState(
      idUsuario: idUsuario ?? this.idUsuario,
      login: login ?? this.login,
      password: password ?? this.password,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      mensaje: mensaje ?? this.mensaje,
      user: user ?? this.user,
    );
  }
}

// Notifier para manejar la autenticación
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Ejecutar la verificación después de que el estado se inicialice
    Future.microtask(() => _checkAuthStatus());
    return const AuthState();
  }

  setIdUsuario(int value) {
    state = state.copyWith(idUsuario: value);
  }

  setLogin(String value) {
    state = state.copyWith(login: value);
  }

  setPassword(String value) {
    state = state.copyWith(password: value);
  }

  setUser(User value) {
    state = state.copyWith(user: value);
  }

  setNumeroDocumento(String value) {
    state = state.copyWith(numeroDocumento: value);
  }

  // Verificar el estado de autenticación al inicializar
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true, mensaje: '');
    //esppera unos 2 segundos
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isLoading: false, mensaje: '');
  }

  // Cerrar sesión
  Future<void> logout() async {
    try {
      await secureStorage.delete(key: 'accessToken');
      await secureStorage.delete(key: 'refreshToken');
      await secureStorage.delete(key: 'verificationToken');
      await secureStorage.delete(key: 'expiresAt');
      await secureStorage.delete(key: 'tokenType');
      await secureStorage.delete(key: 'userName');
      await secureStorage.delete(key: 'passwordTemporary');
      ref.read(navigationIndexProvider.notifier).state = 0;
      //envia a la pantalla de pin
      navigatorKey.currentContext?.go('/pin');
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        mensaje: '',
      );
    }
  }

  void resetearEstado() {
    state = const AuthState();
  }

  // Establecer estado de carga
  void setLoading({required bool isLoading, String mensaje = ''}) {
    state = state.copyWith(isLoading: isLoading, mensaje: mensaje);
  }

  // Limpiar errores
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider para el estado de autenticación
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
final verContrasenyaProvider = StateProvider<bool>((ref) => false);

//Provider para Login
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final dio = ref.read(dioYataProvider);
  return AuthDataSource(dio: dio);
});
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.read(authDataSourceProvider);
  return AuthRepository(dataSource: dataSource);
});

final tokenProvider = StateProvider<String>((ref) {
  return '';
});

final loginPinProvider = FutureProvider<AuthModel>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  final correo = await secureStorage.read(key: 'userCorreo');
  final pinState = ref.watch(pinProvider);
  final fingerprintState = await ref.watch(fingerPrintProvider.future);
  return await repository.postAuthPin(correo ?? '', pinState, fingerprintState);
});

final loginCorreoProvider = FutureProvider<AuthModel>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  final state = ref.watch(authProvider);
  final fingerprintState = await ref.watch(fingerPrintProvider.future);
  final nombreDispositivo = ref.watch(dispositivoProvider).plataforma;
  final ipAddress = ref.watch(dispositivoProvider).ipAddress;
  final userAgent = ref.watch(dispositivoProvider).userAgent;
  return await repository.loginConCorreo(
    state.login,
    state.password,
    fingerprintState,
    nombreDispositivo,
    ipAddress,
    userAgent,
  );
});

final loginCodigoOtpProvider = FutureProvider<AuthModel>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  final codigoOtpState = ref.watch(verifyCodeProvider).codigoOtp;
  final fingerprintState = await ref.watch(fingerPrintProvider.future);
  final verificationTokenState = await ref.watch(
    verificationTokenProvider.future,
  );
  return await repository.verificarCodigoOTP(
    verificationTokenState ?? '',
    codigoOtpState,
    fingerprintState,
  );
});

final logoutProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  final refreshTokenState = await ref.watch(refreshTokenProvider.future);
  final fingerprintState = await ref.watch(fingerPrintProvider.future);
  await repository.logout(refreshTokenState!, fingerprintState);
});

final restaurarClaveProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  final state = ref.watch(authProvider);
  return await repository.restaurarClave(
    state.login,
    state.numeroDocumento,
    state.login,
  );
});
