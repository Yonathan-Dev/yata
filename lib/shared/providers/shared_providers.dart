import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/preferences_service.dart';
import '../services/permissions_service.dart';

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  return PreferencesService();
});

final permissionsServiceProvider = Provider<PermissionsService>((ref) {
  return PermissionsService();
});

// Estado global
class GlobalState {
  final bool cargando;
  final String mensajeCargando;
  final List<EstadoOption> estadoOptions;

  const GlobalState({
    this.cargando = false,
    this.mensajeCargando = '',
    this.estadoOptions = const [],
  });

  GlobalState copyWith({
    bool? cargando,
    String? mensajeCargando,
    List<EstadoOption>? estadoOptions,
  }) {
    return GlobalState(
      cargando: cargando ?? this.cargando,
      mensajeCargando: mensajeCargando ?? this.mensajeCargando,
      estadoOptions: estadoOptions ?? this.estadoOptions,
    );
  }
}

// Modelo para opciones de estado
class EstadoOption {
  final int? vCodEstado;
  final String? vNomEstado;

  const EstadoOption({this.vCodEstado, this.vNomEstado});
}

// Notifier para el estado global
class GlobalNotifier extends StateNotifier<GlobalState> {
  GlobalNotifier() : super(const GlobalState());

  void setCargando(bool value, {String mensaje = ''}) {
    state = state.copyWith(cargando: value, mensajeCargando: mensaje);
  }

  void setEstadoOptions(List<EstadoOption> options) {
    state = state.copyWith(estadoOptions: options);
  }

  String formatearFechaTiempo(DateTime fecha) {
    String dia = fecha.day.toString().padLeft(2, '0');
    String mes = fecha.month.toString().padLeft(2, '0');
    String anio = fecha.year.toString();
    String hora = fecha.hour.toString().padLeft(2, '0');
    String minuto = fecha.minute.toString().padLeft(2, '0');
    String segundo = fecha.second.toString().padLeft(2, '0');

    return '$dia/$mes/$anio $hora:$minuto:$segundo';
  }
}

// Provider para el estado global
final globalProvider = StateNotifierProvider<GlobalNotifier, GlobalState>((
  ref,
) {
  return GlobalNotifier();
});
