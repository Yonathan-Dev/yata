import '../../../../core/app_exports.dart';

class RegisterModel {
  final int iCodigo;
  final String vNombre;
  final String vUnidadOperativa;
  final String vEstado;
  final String vTipo;
  final double dcLatitud;
  final double dcLongitud;

  const RegisterModel({
    required this.iCodigo,
    required this.vNombre,
    required this.vUnidadOperativa,
    required this.vEstado,
    required this.vTipo,
    required this.dcLatitud,
    required this.dcLongitud,
  });

  //recibir datos de un mapa (json)
  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      iCodigo: map['iCodigo']?.toInt() ?? 0,
      vNombre: map['vNombre'] ?? '',
      vUnidadOperativa: map['vUnidadOperativa'] ?? '',
      vEstado: map['vEstado'] ?? '',
      vTipo: map['vTipo'] ?? '',
      dcLatitud: map['dcLatitud']?.toDouble() ?? 0.0,
      dcLongitud: map['dcLongitud']?.toDouble() ?? 0.0,
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
    );
  }
}
