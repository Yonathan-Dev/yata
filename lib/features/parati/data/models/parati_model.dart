class ParatiModel {
  final int? iId;
  final String vObservacion;
  final String vEstado;
  final String vFechaEvento;
  final String vEvento;
  final String vUsuario;
  final String vNombreyata;

  const ParatiModel({
    this.iId,
    required this.vObservacion,
    required this.vEstado,
    required this.vFechaEvento,
    required this.vEvento,
    required this.vUsuario,
    required this.vNombreyata,
  });

  factory ParatiModel.fromJson(Map<String, dynamic> json) => ParatiModel(
    iId: json["iId"],
    vObservacion: json["vObservacion"] ?? '',
    vEstado: json["vEstado"] ?? '',
    vFechaEvento: json["vFechaEvento"] ?? '',
    vEvento: json["vEvento"] ?? '',
    vUsuario: json["vUsuario"] ?? '',
    vNombreyata: json["vNombreyata"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "iId": iId,
    "vObservacion": vObservacion,
    "vEstado": vEstado,
    "vFechaEvento": vFechaEvento,
    "vEvento": vEvento,
    "vUsuario": vUsuario,
    "vNombreyata": vNombreyata,
  };

  copyWith({
    int? iId,
    String? vObservacion,
    String? vEstado,
    String? vFechaEvento,
    String? vEvento,
    String? vUsuario,
    String? vNombreyata,
  }) {
    return ParatiModel(
      iId: iId ?? this.iId,
      vObservacion: vObservacion ?? this.vObservacion,
      vEstado: vEstado ?? this.vEstado,
      vFechaEvento: vFechaEvento ?? this.vFechaEvento,
      vEvento: vEvento ?? this.vEvento,
      vUsuario: vUsuario ?? this.vUsuario,
      vNombreyata: vNombreyata ?? this.vNombreyata,
    );
  }
}
