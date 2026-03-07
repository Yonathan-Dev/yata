import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

// Estado de autenticación
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final String mensaje;
  final User? user;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.mensaje = '',
    this.user,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    String? mensaje,
    User? user,
  }) {
    return AuthState(
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

  // Verificar el estado de autenticación al inicializar
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(
      isLoading: true,
      mensaje: 'Verificando estado de autenticación...',
    );
    //esppera unos 2 segundos
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isLoading: false, mensaje: '');
  }

  // Iniciar sesión
  Future<void> login(String usuario, String password, String plataforma) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      /*final repository = ref.read(authRepositoryProvider);
      state = state.copyWith(mensaje: 'Iniciando sesión...');

      final authModel = await repository.postAuth(
        usuario,
        password,
        plataforma,
      );*/

      /*if (authModel.estado != 1) {
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
          error: 'Usuario inactivo. Contacte al administrador.',
          mensaje: '',
        );
      }
      state = state.copyWith(user: null);

      User user = User(
        id: authModel.usuarioId,
        username: authModel.login,
        password: password,
        name: authModel.descripcion,
        email: authModel.correo,
        isActive: authModel.estado,
        role: authModel.codigoPerfil,
      );*/

      /*final prefsService = ref.read(preferencesServiceProvider);
      await prefsService.saveAuthToken('fake_token');
      await prefsService.saveUserId(user.id.toString());
      if (ref.read(recordarProvider.notifier).state == true) {
        await prefsService.saveSavedUsername(usuario);
        await prefsService.saveSavedPassword(password);
      } else {
        await prefsService.removeSavedUsername();
        await prefsService.removeSavedPassword();
      }

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        mensaje: '',
        user: user,
      );*/
    } on DioException catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        error: e.message ?? 'Error desconocido',
        mensaje: '',
      );
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        error: e.toString(),
        mensaje: '',
      );
    }
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
      ref.read(navigationIndexProvider.notifier).state = 0;
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        mensaje: '',
      );
    }
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
  final state = ref.watch(registerProvider);
  final pinState = ref.watch(pinProvider);
  final fingerprintState = await ref.watch(fingerPrintProvider.future);
  return await repository.postAuthPin(state.correo, pinState, fingerprintState);
});

final loginCorreoProvider = FutureProvider<AuthModel>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  final state = ref.watch(registerProvider);
  final fingerprintState = await ref.watch(fingerPrintProvider.future);
  final nombreDispositivo = ref.watch(dispositivoProvider).plataforma;
  final ipAddress = ref.watch(dispositivoProvider).ipAddress;
  final userAgent = ref.watch(dispositivoProvider).userAgent;
  return await repository.loginConCorreo(
    state.correo,
    state.contrasena,
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
