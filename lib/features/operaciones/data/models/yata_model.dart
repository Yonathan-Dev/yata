import '../../../../core/app_exports.dart';

class YataModel {
  final int iCodigo;
  final String vNombre;
  final String vUnidadOperativa;
  final String vEstado;
  final String vTipo;
  final double dcLatitud;
  final double dcLongitud;
  final List<RecursoModel> recursos;

  const YataModel({
    required this.iCodigo,
    required this.vNombre,
    required this.vUnidadOperativa,
    required this.vEstado,
    required this.vTipo,
    required this.dcLatitud,
    required this.dcLongitud,
    this.recursos = const [],
  });

  //recibir datos de un mapa (json)
  factory YataModel.fromMap(Map<String, dynamic> map) {
    return YataModel(
      iCodigo: map['iCodigo']?.toInt() ?? 0,
      vNombre: map['vNombre'] ?? '',
      vUnidadOperativa: map['vUnidadOperativa'] ?? '',
      vEstado: map['vEstado'] ?? '',
      vTipo: map['vTipo'] ?? '',
      dcLatitud: map['dcLatitud']?.toDouble() ?? 0.0,
      dcLongitud: map['dcLongitud']?.toDouble() ?? 0.0,
      recursos: map['recursos'] != null
          ? List<RecursoModel>.from(
              map['recursos'].map((x) => RecursoModel.fromMap(x)),
            )
          : [],
    );
  }

  copyWith({
    int? iCodigo,
    String? vNombre,
    String? vUnidadOperativa,
    String? vEstado,
    String? vTipo,
    double? dcLatitud,
    double? dcLongitud,
    List<RecursoModel>? recursos,
  }) {
    return YataModel(
      iCodigo: iCodigo ?? this.iCodigo,
      vNombre: vNombre ?? this.vNombre,
      vUnidadOperativa: vUnidadOperativa ?? this.vUnidadOperativa,
      vEstado: vEstado ?? this.vEstado,
      vTipo: vTipo ?? this.vTipo,
      dcLatitud: dcLatitud ?? this.dcLatitud,
      dcLongitud: dcLongitud ?? this.dcLongitud,
      recursos: recursos ?? this.recursos,
    );
  }
}
