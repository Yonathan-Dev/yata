class AuthModel {
  int idUsuario;
  String login;
  String apellidosyNombres;
  String correoInstitucional;
  String numeroDocumento;
  String accessToken;
  String refreshToken;
  DateTime expiresAt;
  String tokenType;
  bool requiereVerificacion;

  AuthModel({
    required this.idUsuario,
    required this.login,
    required this.apellidosyNombres,
    required this.correoInstitucional,
    required this.numeroDocumento,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.tokenType,
    required this.requiereVerificacion,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    idUsuario: json["idUsuario"],
    login: json["login"],
    apellidosyNombres: json["ApellidosyNombres"],
    correoInstitucional: json["correoInstitucional"],
    numeroDocumento: json["numeroDocumento"],
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
    expiresAt: DateTime.parse(json["expiresAt"]),
    tokenType: json["tokenType"],
    requiereVerificacion: json["requiereVerificacion"],
  );

  Map<String, dynamic> toJson() => {
    "idUsuario": idUsuario,
    "login": login,
    "ApellidosyNombres": apellidosyNombres,
    "correoInstitucional": correoInstitucional,
    "numeroDocumento": numeroDocumento,
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "expiresAt": expiresAt.toIso8601String(),
    "tokenType": tokenType,
    "requiereVerificacion": requiereVerificacion,
  };
}
