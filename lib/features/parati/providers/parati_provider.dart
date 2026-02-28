import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class ParatiNotifier extends Notifier<List<ParatiModel>> {
  @override
  List<ParatiModel> build() {
    return [];
  }

  void cargarTrazabilidad(List<ParatiModel> trazabilidades) {
    state = trazabilidades;
  }

  void resetTrazabilidad() {
    state = [];
  }
}

final paratiProvider = NotifierProvider<ParatiNotifier, List<ParatiModel>>(() {
  return ParatiNotifier();
});

final paratiRepositoryProvider = Provider<ParatiRepository>((ref) {
  final dataSource = ref.watch(paratiDataSourceProvider);
  return ParatiRepository(dataSource: dataSource);
});

final paratiDataSourceProvider = Provider<ParatiDataSource>((ref) {
  final dio = ref.watch(dioYataProvider);
  return ParatiDataSource(dio: dio);
});

final isLoadingParatiProvider = StateProvider<bool>((ref) => true);
