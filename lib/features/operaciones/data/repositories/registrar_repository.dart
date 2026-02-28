import 'dart:io';

import '../../../../core/app_exports.dart';

class RegistrarRepository {
  final RegistrarDataSource dataSource;

  RegistrarRepository({required this.dataSource});

  Future<String> enviarRegistro(
    String vUsuario,
    String vFechaEvento,
    RegistrarStateOperaciones state,
    String vEvento,
  ) async {
    try {
      final Map<String, dynamic> requestData = {
        'iCodigoyata': state.codigo,
        'vNombreyata': state.nombre,
        'vUnidadOperativa': state.unidadOperativa,
        'vEstado': state.estado,
        'vTipo': state.tipo,
        'vAlerta': state.alerta,
        'vObservacion': state.observacion,
        'vImagen1': state.imagen1,
        'vImagen2': state.imagen2,
        'xidRecursos': state.recursos
            .map(
              (recurso) => {
                'vNombre': recurso.vNombre,
                'iCantidad': recurso.iCantidad,
                'vRequerido': recurso.vRequerido,
              },
            )
            .toList(),
      };
      final response = await dataSource.enviarRegistro(
        vUsuario,
        vFechaEvento,
        state.codigo,
        state.nombre,
        state.alerta,
        state.estado,
        state.observacion,
        vEvento,
        requestData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadFoto(File imageFile, String tokenStorage) async {
    try {
      final response = await dataSource.uploadFoto(imageFile, tokenStorage);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<YataModel?> obteneryataOperador(String vUsuario) async {
    try {
      final response = await dataSource.obteneryataOperador(vUsuario);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
