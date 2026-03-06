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
  String verificationToken;
  String verificationMethod;
  String mensajeVerificacion;

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
    required this.verificationToken,
    required this.verificationMethod,
    required this.mensajeVerificacion,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    idUsuario: json["idUsuario"] ?? 0,
    login: json["login"] ?? '',
    apellidosyNombres: json["ApellidosyNombres"] ?? '',
    correoInstitucional: json["correoInstitucional"] ?? '',
    numeroDocumento: json["numeroDocumento"] ?? '',
    accessToken: json["accessToken"] ?? '',
    refreshToken: json["refreshToken"] ?? '',
    expiresAt: json["expiresAt"] != null
        ? DateTime.parse(json["expiresAt"])
        : DateTime.now(),
    tokenType: json["tokenType"] ?? '',
    requiereVerificacion: json["requiereVerificacion"] ?? false,
    verificationToken: json["verificationToken"] ?? '',
    verificationMethod: json["verificationMethod"] ?? '',
    mensajeVerificacion: json["mensajeVerificacion"] ?? '',
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
    "verificationToken": verificationToken,
    "verificationMethod": verificationMethod,
    "mensajeVerificacion": mensajeVerificacion,
  };
}
