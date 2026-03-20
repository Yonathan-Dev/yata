import 'package:flutter_riverpod/flutter_riverpod.dart';

// Modelo de registrar PIN
class RegisterPinState {
  final String pin;
  final String confirmPin;
  final String error;
  final bool isLoading;
  final String mensaje;

  RegisterPinState({
    this.pin = '',
    this.confirmPin = '',
    this.error = '',
    this.isLoading = false,
    this.mensaje = '',
  });

  RegisterPinState copyWith({
    String? pin,
    String? confirmPin,
    String? error,
    bool? isLoading,
    String? mensaje,
  }) {
    return RegisterPinState(
      pin: pin ?? this.pin,
      confirmPin: confirmPin ?? this.confirmPin,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      mensaje: mensaje ?? this.mensaje,
    );
  }
}

// Notifier para manejar el estado de registrar PIN
class RegisterPinNotifier extends Notifier<RegisterPinState> {
  @override
  RegisterPinState build() {
    return RegisterPinState();
  }

  void setPin(String value) {
    state = state.copyWith(pin: value);
  }

  void setConfirmPin(String value) {
    state = state.copyWith(confirmPin: value);
  }

  void setIsLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void setMensaje(String value) {
    state = state.copyWith(mensaje: value);
  }

  void resetEstado() {
    state = RegisterPinState();
  }

  //validar campo
  String? validarCampo(String value, String campo) {
    if (value.isEmpty || value == 'null') {
      return 'El campo $campo es obligatorio';
    }
    return null;
  }

  void capturarDatosPin({required String pin, required String confirmPin}) {
    state = state.copyWith(pin: pin, confirmPin: confirmPin);
  }

  //validar que los PIN coincidan
  bool? validarPin() {
    if (state.pin != state.confirmPin) {
      return false;
    }
    return true;
  }
}

final registerPinProvider =
    NotifierProvider<RegisterPinNotifier, RegisterPinState>(() {
      return RegisterPinNotifier();
    });
