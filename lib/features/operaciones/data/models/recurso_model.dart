class RecursoModel {
  final String vNombre;
  final int iCantidad;
  final String vRequerido;

  const RecursoModel({
    required this.vNombre,
    required this.iCantidad,
    this.vRequerido = 'No',
  });

  //recibir datos de un mapa (json)
  factory RecursoModel.fromMap(Map<String, dynamic> map) {
    return RecursoModel(
      vNombre: map['vNombre'] ?? '',
      iCantidad: map['iCantidad'] ?? 0,
      vRequerido: map['vRequerido'] ?? 'No',
    );
  }

  copyWith({String? vNombre, int? iCantidad, String? vRequerido}) {
    return RecursoModel(
      vNombre: vNombre ?? this.vNombre,
      iCantidad: iCantidad ?? this.iCantidad,
      vRequerido: vRequerido ?? this.vRequerido,
    );
  }
}
