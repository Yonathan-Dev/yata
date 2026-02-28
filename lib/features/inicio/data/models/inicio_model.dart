class InicioModel {
  final int iCodigo;
  final String vNombre;
  final String vDepartamento;
  final String vProvincia;
  final String vDistrito;
  final String vLocalidad;
  final int iEstado;
  final String vCodigo;
  final String vDescripcion;
  final String vTipo;
  final String vFecha;
  final double dcLatitud;
  final double dcLongitud;

  const InicioModel({
    required this.iCodigo,
    required this.vNombre,
    required this.vDepartamento,
    required this.vProvincia,
    required this.vDistrito,
    required this.vLocalidad,
    required this.iEstado,
    required this.vCodigo,
    required this.vDescripcion,
    required this.vTipo,
    required this.vFecha,
    required this.dcLatitud,
    required this.dcLongitud,
  });

  InicioModel copyWith({
    int? iCodigo,
    String? vNombre,
    String? vDepartamento,
    String? vProvincia,
    String? vDistrito,
    String? vLocalidad,
    int? iEstado,
    String? vCodigo,
    String? vDescripcion,
    String? vTipo,
    String? vFecha,
    double? dcLatitud,
    double? dcLongitud,
  }) {
    return InicioModel(
      iCodigo: iCodigo ?? this.iCodigo,
      vNombre: vNombre ?? this.vNombre,
      vDepartamento: vDepartamento ?? this.vDepartamento,
      vProvincia: vProvincia ?? this.vProvincia,
      vDistrito: vDistrito ?? this.vDistrito,
      vLocalidad: vLocalidad ?? this.vLocalidad,
      iEstado: iEstado ?? this.iEstado,
      vCodigo: vCodigo ?? this.vCodigo,
      vDescripcion: vDescripcion ?? this.vDescripcion,
      vTipo: vTipo ?? this.vTipo,
      vFecha: vFecha ?? this.vFecha,
      dcLatitud: dcLatitud ?? this.dcLatitud,
      dcLongitud: dcLongitud ?? this.dcLongitud,
    );
  }

  factory InicioModel.fromJson(Map<String, dynamic> json) => InicioModel(
    iCodigo: json['iCodigo'] ?? 0,
    vNombre: json['vNombre'] ?? '',
    vDepartamento: json['vDepartamento'] ?? '',
    vProvincia: json['vProvincia'] ?? '',
    vDistrito: json['vDistrito'] ?? '',
    vLocalidad: json['vLocalidad'] ?? '',
    vTipo: json['vTipo'] ?? '',
    iEstado: json['iEstado'] ?? 0,
    vCodigo: json['vCodigo'] ?? '',
    vDescripcion: json['vDescripcion'] ?? '',
    vFecha: json['vFecha'] ?? '',
    dcLatitud: json['dcLatitud'] ?? 0.0,
    dcLongitud: json['dcLongitud'] ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    'iCodigo': iCodigo,
    'vNombre': vNombre,
    'vDepartamento': vDepartamento,
    'vProvincia': vProvincia,
    'vDistrito': vDistrito,
    'vLocalidad': vLocalidad,
    'iEstado': iEstado,
    'vCodigo': vCodigo,
    'vDescripcion': vDescripcion,
    'vTipo': vTipo,
    'vFecha': vFecha,
    'dcLatitud': dcLatitud,
    'dcLongitud': dcLongitud,
  };

  factory InicioModel.empty() {
    return const InicioModel(
      iCodigo: 0,
      vNombre: '',
      vDepartamento: '',
      vProvincia: '',
      vDistrito: '',
      vLocalidad: '',
      iEstado: 0,
      vCodigo: '',
      vDescripcion: '',
      vTipo: '',
      vFecha: '',
      dcLatitud: 0.0,
      dcLongitud: 0.0,
    );
  }
}
