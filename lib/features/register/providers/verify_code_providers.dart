import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

// Modelo de verificación de código OTP
class VerifyCodeState {
  final String codigoOtp;
  final String error;
  final bool isLoading;
  final String mensaje;

  VerifyCodeState({
    this.codigoOtp = '',
    this.error = '',
    this.isLoading = false,
    this.mensaje = '',
  });

  VerifyCodeState copyWith({
    String? codigoOtp,
    String? error,
    bool? isLoading,
    String? mensaje,
  }) {
    return VerifyCodeState(
      codigoOtp: codigoOtp ?? this.codigoOtp,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      mensaje: mensaje ?? this.mensaje,
    );
  }
}

// Notifier para manejar el estado de ubicación
class VerifyCodeNotifier extends Notifier<VerifyCodeState> {
  @override
  VerifyCodeState build() {
    return VerifyCodeState();
  }

  void setCodigoOtp(String value) {
    state = state.copyWith(codigoOtp: value);
  }

  void setError(String value) {
    state = state.copyWith(error: value);
  }

  void setIsLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void setMensaje(String value) {
    state = state.copyWith(mensaje: value);
  }

  void resetEstado() {
    state = VerifyCodeState();
  }

  //validar campo
  String? validarCampo(String value, String campo) {
    if (value.isEmpty || value == 'null') {
      return 'El campo $campo es obligatorio';
    }
    return null;
  }

  void capturarDatosVerifyCode({required String codigoOtp}) {
    state = state.copyWith(codigoOtp: codigoOtp);
  }
}

final verifyCodeProvider =
    NotifierProvider<VerifyCodeNotifier, VerifyCodeState>(() {
      return VerifyCodeNotifier();
    });

final verifyCodeDataSourceProvider = Provider<RegisterDataSource>((ref) {
  final dio = ref.watch(dioYataProvider);
  return RegisterDataSource(dio: dio);
});

final verifyCodeRepositoryProvider = Provider<RegisterRepository>((ref) {
  final dataSource = ref.watch(verifyCodeDataSourceProvider);
  return RegisterRepository(dataSource: dataSource);
});

final enviarCodigoOTPProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(verifyCodeRepositoryProvider);
  final state = ref.watch(verifyCodeProvider);
  final registerState = ref.watch(registerProvider);
  return await repository.enviarVerificacionCodigoOTP(state, registerState);
});
