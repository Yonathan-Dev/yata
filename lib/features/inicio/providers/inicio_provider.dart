import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class InicioNotifier extends Notifier<List<InicioModel>> {
  @override
  List<InicioModel> build() {
    return [];
  }

  Future<void> listarTodosyatas() async {
    try {
      final repository = ref.read(inicioRepositoryProvider);
      final yatas = await repository.listarTodosyatas();

      state = yatas;
      ref.read(yatasObtenidosProvider.notifier).state = true;
    } catch (error) {
      state = [];
      ref.read(yatasObtenidosProvider.notifier).state = false;
      rethrow;
    }
  }

  void resetEstado() {
    state = [];
    ref.read(yatasObtenidosProvider.notifier).state = false;
  }
}

//Provider para obtener la lista de yatas y manejar su estado
final inicioProvider = NotifierProvider<InicioNotifier, List<InicioModel>>(() {
  return InicioNotifier();
});

final ubicacionObtenidaProvider = StateProvider<bool>((ref) => false);
final yatasObtenidosProvider = StateProvider<bool>((ref) => false);
final mapaCreadoProvider = StateProvider<bool>((ref) => false);
final mostrarLeyendaProvider = StateProvider<bool>((ref) => false);

//Provider de DataSource, Repository y UseCase para obtener un yata específico por su código
final yataProvider = FutureProvider.family<InicioModel, int>((
  ref,
  codigo,
) async {
  final repository = ref.watch(inicioRepositoryProvider);
  final result = await repository.listaryata(codigo);
  if (result == null) {
    throw Exception('No se pudo obtener el yata con código $codigo');
  }
  return result;
});

final inicioRepositoryProvider = Provider<InicioRepository>((ref) {
  final dataSource = ref.watch(inicioDataSourceProvider);
  return InicioRepository(dataSource: dataSource);
});

final inicioDataSourceProvider = Provider<InicioDataSource>((ref) {
  final dio = ref.watch(dioEmergenciasProvider);
  return InicioDataSource(dio: dio);
});
