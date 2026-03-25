import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class ConsultarSaldoState {
  final bool success;
  final double saldo;
  final double saldoReservado;
  final double saldoDisponible;
  final DateTime fechaActualizacion;
  final String error;
  final bool isLoading;

  ConsultarSaldoState({
    this.success = false,
    this.saldo = 0.00,
    this.saldoReservado = 0.00,
    this.saldoDisponible = 0.00,
    DateTime? fechaActualizacion,
    this.error = '',
    this.isLoading = false,
  }) : fechaActualizacion = fechaActualizacion ?? DateTime.now();

  ConsultarSaldoState copyWith({
    bool? success,
    double? saldo,
    double? saldoReservado,
    double? saldoDisponible,
    DateTime? fechaActualizacion,
    String? error,
    bool? isLoading,
  }) {
    return ConsultarSaldoState(
      success: success ?? this.success,
      saldo: saldo ?? this.saldo,
      saldoReservado: saldoReservado ?? this.saldoReservado,
      saldoDisponible: saldoDisponible ?? this.saldoDisponible,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class InicioNotifier extends Notifier<ConsultarSaldoState> {
  @override
  ConsultarSaldoState build() {
    return ConsultarSaldoState();
  }

  void setSuccess(bool value) {
    state = state.copyWith(success: value);
  }

  void setSaldo(double value) {
    state = state.copyWith(saldo: value);
  }

  void setSaldoReservado(double value) {
    state = state.copyWith(saldoReservado: value);
  }

  void setSaldoDisponible(double value) {
    state = state.copyWith(saldoDisponible: value);
  }

  void setFechaActualizacion(DateTime value) {
    state = state.copyWith(fechaActualizacion: value);
  }

  void setError(String value) {
    state = state.copyWith(error: value);
  }

  void setIsLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void resetEstado() {
    state = ConsultarSaldoState();
  }
}

//Provider para obtener la lista de yatas y manejar su estado
final inicioProvider = NotifierProvider<InicioNotifier, ConsultarSaldoState>(
  () {
    return InicioNotifier();
  },
);

final inicioRepositoryProvider = Provider<InicioRepository>((ref) {
  final dataSource = ref.watch(inicioDataSourceProvider);
  return InicioRepository(dataSource: dataSource);
});

final inicioDataSourceProvider = Provider<InicioDataSource>((ref) {
  final dio = ref.watch(dioYataAuthProvider);
  return InicioDataSource(dio: dio);
});

final consultarSaldoProvider = FutureProvider.autoDispose<SaldoModel?>((
  ref,
) async {
  final authState = ref.watch(authProvider);
  final idUsuario = authState.user?.idUsuario;

  if (idUsuario == null) {
    throw Exception('Usuario no autenticado');
  }

  final repository = ref.watch(inicioRepositoryProvider);
  final saldo = await repository.consultarSaldo(idUsuario);
  return saldo;
});

final mostrarMovimientos = StateProvider<bool>((ref) => false);
final mostrarSaldo = StateProvider<bool>((ref) => false);
