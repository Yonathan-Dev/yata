class SaldoModel {
  final bool success;
  final double saldo;
  final double saldoReservado;
  final double saldoDisponible;
  final DateTime fechaActualizacion;

  const SaldoModel({
    required this.success,
    required this.saldo,
    required this.saldoReservado,
    required this.saldoDisponible,
    required this.fechaActualizacion,
  });

  SaldoModel copyWith({
    bool? success,
    double? saldo,
    double? saldoReservado,
    double? saldoDisponible,
    DateTime? fechaActualizacion,
  }) {
    return SaldoModel(
      success: success ?? this.success,
      saldo: saldo ?? this.saldo,
      saldoReservado: saldoReservado ?? this.saldoReservado,
      saldoDisponible: saldoDisponible ?? this.saldoDisponible,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  factory SaldoModel.fromJson(Map<String, dynamic> json) => SaldoModel(
    success: json['success'] ?? false,
    saldo: (json['saldo'] ?? 0.00).toDouble(),
    saldoReservado: (json['saldoReservado'] ?? 0.00).toDouble(),
    saldoDisponible: (json['saldoDisponible'] ?? 0.00).toDouble(),
    fechaActualizacion:
        json['fechaActualizacion'] != null &&
            json['fechaActualizacion'] is String
        ? DateTime.parse(json['fechaActualizacion'])
        : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'saldo': saldo,
    'saldoReservado': saldoReservado,
    'saldoDisponible': saldoDisponible,
    'fechaActualizacion': fechaActualizacion.toIso8601String(),
  };
}
