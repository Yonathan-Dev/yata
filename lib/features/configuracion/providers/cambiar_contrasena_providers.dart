import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

//estado para cambiar contraseña
class CambiarContrasenaState {
  final String correo;
  final String codigoOtp;
  final String contrasenaActual;
  final String nuevaContrasena;
  final String confirmarContrasena;
  final bool isLoading;
  final String mensaje;
  final String? error;

  CambiarContrasenaState({
    this.correo = '',
    this.codigoOtp = '',
    this.contrasenaActual = '',
    this.nuevaContrasena = '',
    this.confirmarContrasena = '',
    this.isLoading = false,
    this.mensaje = '',
    this.error,
  });

  CambiarContrasenaState copyWith({
    String? correo,
    String? codigoOtp,
    String? contrasenaActual,
    String? nuevaContrasena,
    String? confirmarContrasena,
    bool? isLoading,
    String? mensaje,
    String? error,
  }) {
    return CambiarContrasenaState(
      correo: correo ?? this.correo,
      codigoOtp: codigoOtp ?? this.codigoOtp,
      contrasenaActual: contrasenaActual ?? this.contrasenaActual,
      nuevaContrasena: nuevaContrasena ?? this.nuevaContrasena,
      confirmarContrasena: confirmarContrasena ?? this.confirmarContrasena,
      isLoading: isLoading ?? this.isLoading,
      mensaje: mensaje ?? this.mensaje,
      error: error ?? this.error,
    );
  }
}

class CambiarContrasenaNotifier extends StateNotifier<CambiarContrasenaState> {
  CambiarContrasenaNotifier() : super(CambiarContrasenaState());

  void setCorreo(String correo) {
    state = state.copyWith(correo: correo);
  }

  void setCodigoOtp(String codigo) {
    state = state.copyWith(codigoOtp: codigo);
  }

  void setContrasenaActual(String contrasena) {
    state = state.copyWith(contrasenaActual: contrasena);
  }

  void setNuevaContrasena(String contrasena) {
    state = state.copyWith(nuevaContrasena: contrasena);
  }

  void setConfirmarContrasena(String contrasena) {
    state = state.copyWith(confirmarContrasena: contrasena);
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
    state = CambiarContrasenaState();
  }

  String? validarCampo(String value, String campo) {
    if (value.isEmpty || value == 'null') {
      return 'El campo $campo es obligatorio';
    }
    if (value.length < 8) {
      return 'Mínimo 8 caracteres';
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
      await secureStorage.delete(key: 'flagRegistrado');

      navigatorKey.currentContext?.go('/auth');
      state = CambiarContrasenaState();
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
    required String contrasenaActual,
    required String nuevaContrasena,
    required String confirmarContrasena,
  }) {
    state = state.copyWith(
      correo: correo,
      codigoOtp: codigoOtp,
      contrasenaActual: contrasenaActual,
      nuevaContrasena: nuevaContrasena,
      confirmarContrasena: confirmarContrasena,
    );
  }
}

final filledFieldsProvider = StateProvider<List<bool>>((ref) {
  return List.generate(6, (_) => false);
});

final showActualPasswordProvider = StateProvider<bool>((ref) => false);
final showNuevaPasswordProvider = StateProvider<bool>((ref) => false);
final showConfirmPasswordProvider = StateProvider<bool>((ref) => false);

final cambiarContrasenaProvider =
    StateNotifierProvider<CambiarContrasenaNotifier, CambiarContrasenaState>(
      (ref) => CambiarContrasenaNotifier(),
    );

final cambiarContrasenaDataSourceProvider = Provider<ConfiguracionDataSource>((
  ref,
) {
  final dio = ref.read(dioYataAuthProvider);
  return ConfiguracionDataSource(dio: dio);
});

final cambiarContrasenaRepositoryProvider = Provider<ConfiguracionRepository>((
  ref,
) {
  final dataSource = ref.read(cambiarContrasenaDataSourceProvider);
  return ConfiguracionRepository(dataSource: dataSource);
});

final solicitarCodigoOtpProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(cambiarContrasenaRepositoryProvider);
  final idUsuario = ref.watch(authProvider).user?.idUsuario ?? 0;
  final login = ref.watch(authProvider).user?.login ?? '';
  return await repository.solicitarCodigoOtp(idUsuario, login);
});

final enviarVerificacionCodigoOTPProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(cambiarContrasenaRepositoryProvider);
  final correo = ref.watch(cambiarContrasenaProvider).correo;
  final codigoOtp = ref.watch(cambiarContrasenaProvider).codigoOtp;
  return await repository.enviarVerificacionCodigoOTP(correo, codigoOtp);
});

final solicitarCambioContrasenaProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(cambiarContrasenaRepositoryProvider);
  final idUsuario = ref.watch(authProvider).user?.idUsuario ?? 0;
  final login = ref.watch(cambiarContrasenaProvider).correo;
  final contrasenaActual = ref
      .watch(cambiarContrasenaProvider)
      .contrasenaActual;
  final nuevaContrasena = ref.watch(cambiarContrasenaProvider).nuevaContrasena;
  final codigoOtp = ref.watch(cambiarContrasenaProvider).codigoOtp;
  return await repository.solicitarCambioConstrasena(
    idUsuario,
    login,
    contrasenaActual,
    nuevaContrasena,
    codigoOtp,
  );
});
