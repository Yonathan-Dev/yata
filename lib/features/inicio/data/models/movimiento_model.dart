class MovimientoModel {
  bool success;
  List<Datum> data;
  int page;
  int pageSize;
  int totalRegistros;
  int totalPaginas;
  bool tieneSiguiente;
  bool tieneAnterior;

  MovimientoModel({
    required this.success,
    required this.data,
    required this.page,
    required this.pageSize,
    required this.totalRegistros,
    required this.totalPaginas,
    required this.tieneSiguiente,
    required this.tieneAnterior,
  });

  MovimientoModel copyWith({
    bool? success,
    List<Datum>? data,
    int? page,
    int? pageSize,
    int? totalRegistros,
    int? totalPaginas,
    bool? tieneSiguiente,
    bool? tieneAnterior,
  }) => MovimientoModel(
    success: success ?? this.success,
    data: data ?? this.data,
    page: page ?? this.page,
    pageSize: pageSize ?? this.pageSize,
    totalRegistros: totalRegistros ?? this.totalRegistros,
    totalPaginas: totalPaginas ?? this.totalPaginas,
    tieneSiguiente: tieneSiguiente ?? this.tieneSiguiente,
    tieneAnterior: tieneAnterior ?? this.tieneAnterior,
  );

  factory MovimientoModel.fromJson(Map<String, dynamic> json) =>
      MovimientoModel(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        page: json["page"],
        pageSize: json["pageSize"],
        totalRegistros: json["totalRegistros"],
        totalPaginas: json["totalPaginas"],
        tieneSiguiente: json["tieneSiguiente"],
        tieneAnterior: json["tieneAnterior"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "page": page,
    "pageSize": pageSize,
    "totalRegistros": totalRegistros,
    "totalPaginas": totalPaginas,
    "tieneSiguiente": tieneSiguiente,
    "tieneAnterior": tieneAnterior,
  };
}

class Datum {
  int idtransaccion;
  double monto;
  String tipo;
  String estado;
  int idestado;
  String estadoDescripcion;
  String descripcion;
  DateTime fechaTransaccion;
  String referencia;
  double saldoAnterior;
  double saldoPosterior;

  Datum({
    required this.idtransaccion,
    required this.monto,
    required this.tipo,
    required this.estado,
    required this.idestado,
    required this.estadoDescripcion,
    required this.descripcion,
    required this.fechaTransaccion,
    required this.referencia,
    required this.saldoAnterior,
    required this.saldoPosterior,
  });

  Datum copyWith({
    int? idtransaccion,
    double? monto,
    String? tipo,
    String? estado,
    int? idestado,
    String? estadoDescripcion,
    String? descripcion,
    DateTime? fechaTransaccion,
    String? referencia,
    double? saldoAnterior,
    double? saldoPosterior,
  }) => Datum(
    idtransaccion: idtransaccion ?? this.idtransaccion,
    monto: monto ?? this.monto,
    tipo: tipo ?? this.tipo,
    estado: estado ?? this.estado,
    idestado: idestado ?? this.idestado,
    estadoDescripcion: estadoDescripcion ?? this.estadoDescripcion,
    descripcion: descripcion ?? this.descripcion,
    fechaTransaccion: fechaTransaccion ?? this.fechaTransaccion,
    referencia: referencia ?? this.referencia,
    saldoAnterior: saldoAnterior ?? this.saldoAnterior,
    saldoPosterior: saldoPosterior ?? this.saldoPosterior,
  );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    idtransaccion: json["idtransaccion"],
    monto: json["monto"],
    tipo: json["tipo"],
    estado: json["estado"],
    idestado: json["idestado"],
    estadoDescripcion: json["estadoDescripcion"],
    descripcion: json["descripcion"],
    fechaTransaccion: DateTime.parse(json["fechaTransaccion"]),
    referencia: json["referencia"],
    saldoAnterior: json["saldoAnterior"],
    saldoPosterior: json["saldoPosterior"],
  );

  Map<String, dynamic> toJson() => {
    "idtransaccion": idtransaccion,
    "monto": monto,
    "tipo": tipo,
    "estado": estado,
    "idestado": idestado,
    "estadoDescripcion": estadoDescripcion,
    "descripcion": descripcion,
    "fechaTransaccion": fechaTransaccion.toIso8601String(),
    "referencia": referencia,
    "saldoAnterior": saldoAnterior,
    "saldoPosterior": saldoPosterior,
  };
}
