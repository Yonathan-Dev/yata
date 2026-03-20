class PerfilModel {
  int idUsuario;
  String login;
  String celular;
  bool sexo;
  String genero;
  bool tienePinConfigurado;
  int idPersona;
  int idTipoDocumento;
  String numeroDocumento;
  String primerApellido;
  String segundoApellido;
  String nombres;
  String fechaNacimiento;
  String correo;

  PerfilModel({
    required this.idUsuario,
    required this.login,
    required this.celular,
    required this.sexo,
    required this.genero,
    required this.tienePinConfigurado,
    required this.idPersona,
    required this.idTipoDocumento,
    required this.numeroDocumento,
    required this.primerApellido,
    required this.segundoApellido,
    required this.nombres,
    required this.fechaNacimiento,
    required this.correo,
  });

  factory PerfilModel.fromJson(Map<String, dynamic> json) => PerfilModel(
    idUsuario: json["idUsuario"] ?? 0,
    login: json["login"] ?? '',
    celular: json["celular"] ?? '',
    sexo: json["sexo"] ?? false,
    genero: json["genero"] ?? '',
    tienePinConfigurado: json["tienePinConfigurado"] ?? false,
    idPersona: json["idPersona"] ?? 0,
    idTipoDocumento: json["idTipoDocumento"] ?? 0,
    numeroDocumento: json["numeroDocumento"] ?? '',
    primerApellido: json["primerApellido"] ?? '',
    segundoApellido: json["segundoApellido"] ?? '',
    nombres: json["nombres"] ?? '',
    fechaNacimiento: json["fechaNacimiento"] ?? '',
    correo: json["correo"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "idUsuario": idUsuario,
    "login": login,
    "celular": celular,
    "sexo": sexo,
    "genero": genero,
    "tienePinConfigurado": tienePinConfigurado,
    "idPersona": idPersona,
    "idTipoDocumento": idTipoDocumento,
    "numeroDocumento": numeroDocumento,
    "primerApellido": primerApellido,
    "segundoApellido": segundoApellido,
    "nombres": nombres,
    "fechaNacimiento": fechaNacimiento,
    "correo": correo,
  };
}
