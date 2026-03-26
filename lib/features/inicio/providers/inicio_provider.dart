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

final movimientosProvider = FutureProvider.autoDispose<MovimientoModel?>((
  ref,
) async {
  final authState = ref.watch(authProvider);
  final idUsuario = authState.user?.idUsuario;

  if (idUsuario == null) {
    throw Exception('Usuario no autenticado');
  }

  final repository = ref.watch(inicioRepositoryProvider);
  final movimientos = await repository.consultarMovimientos(idUsuario, 1, 20);
  return movimientos;
});

// Notifier para manejar paginación de movimientos
class MovimientosState {
  final List<Datum> items;
  final int page;
  final int pageSize;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasNext;
  final String error;
  final int totalPaginas;
  final int totalRegistros;

  MovimientosState({
    this.items = const [],
    this.page = 1,
    this.pageSize = 20,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasNext = false,
    this.error = '',
    this.totalPaginas = 0,
    this.totalRegistros = 0,
  });

  MovimientosState copyWith({
    List<Datum>? items,
    int? page,
    int? pageSize,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasNext,
    String? error,
    int? totalPaginas,
    int? totalRegistros,
  }) {
    return MovimientosState(
      items: items ?? this.items,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNext: hasNext ?? this.hasNext,
      error: error ?? this.error,
      totalPaginas: totalPaginas ?? this.totalPaginas,
      totalRegistros: totalRegistros ?? this.totalRegistros,
    );
  }
}

class MovimientosNotifier extends Notifier<MovimientosState> {
  @override
  MovimientosState build() {
    return MovimientosState();
  }

  Future<int> loadInitial() async {
    if (state.isLoading) return 0;
    state = state.copyWith(isLoading: true, error: '');
    final authState = ref.watch(authProvider);
    final idUsuario = authState.user?.idUsuario;
    if (idUsuario == null) {
      state = state.copyWith(isLoading: false, error: 'Usuario no autenticado');
      return 0;
    }

    try {
      final repository = ref.watch(inicioRepositoryProvider);
      final resp = await repository.consultarMovimientos(
        idUsuario,
        1,
        state.pageSize,
      );
      if (resp != null) {
        // Reemplazar la lista inicial; eliminar duplicados por idtransaccion
        final unique = <int>{};
        final filtered = <Datum>[];
        for (final d in resp.data) {
          if (!unique.contains(d.idtransaccion)) {
            unique.add(d.idtransaccion);
            filtered.add(d);
          }
        }
        state = state.copyWith(
          items: filtered,
          page: resp.page,
          hasNext: resp.tieneSiguiente,
          isLoading: false,
          totalPaginas: resp.totalPaginas,
          totalRegistros: resp.totalRegistros,
        );
        return filtered.length;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Error al obtener movimientos',
        );
        return 0;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return 0;
    }
  }

  Future<int> loadMore() async {
    if (state.isLoadingMore || !state.hasNext) return 0;
    state = state.copyWith(isLoadingMore: true, error: '');
    final authState = ref.watch(authProvider);
    final idUsuario = authState.user?.idUsuario;
    if (idUsuario == null) {
      state = state.copyWith(
        isLoadingMore: false,
        error: 'Usuario no autenticado',
      );
      return 0;
    }

    try {
      final repository = ref.watch(inicioRepositoryProvider);
      final nextPage = state.page + 1;
      final resp = await repository.consultarMovimientos(
        idUsuario,
        nextPage,
        state.pageSize,
      );
      if (resp != null) {
        // Evitar duplicados: filtrar resp.data por idtransaccion ya presentes
        final existingIds = state.items.map((e) => e.idtransaccion).toSet();
        final newItems = resp.data
            .where((d) => !existingIds.contains(d.idtransaccion))
            .toList();
        final combined = List<Datum>.from(state.items)..addAll(newItems);
        state = state.copyWith(
          items: combined,
          page: resp.page,
          hasNext: resp.tieneSiguiente,
          isLoadingMore: false,
          totalPaginas: resp.totalPaginas,
          totalRegistros: resp.totalRegistros,
        );
        return newItems.length;
      } else {
        state = state.copyWith(
          isLoadingMore: false,
          error: 'Error al obtener más movimientos',
        );
        return 0;
      }
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
      return 0;
    }
  }
}

final movimientosNotifierProvider =
    NotifierProvider<MovimientosNotifier, MovimientosState>(() {
      return MovimientosNotifier();
    });
