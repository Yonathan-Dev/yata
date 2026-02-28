class AuthModel {
  int usuarioId;
  String login;
  String nroDocumento;
  String tipoDocumento;
  String descripcion;
  String nombres;
  String apePaterno;
  String apeMaterno;
  int estado;
  String correo;
  int codigoPerfil;

  AuthModel({
    required this.usuarioId,
    required this.login,
    required this.nroDocumento,
    required this.tipoDocumento,
    required this.descripcion,
    required this.nombres,
    required this.apePaterno,
    required this.apeMaterno,
    required this.estado,
    required this.correo,
    required this.codigoPerfil,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    usuarioId: json['USUARIO_ID'] ?? 0,
    login: json['LOGIN'] ?? "",
    nroDocumento: json['NRO_DOCUMENTO'] ?? "",
    tipoDocumento: json['TIPO_DOCUMENTO'] ?? "",
    descripcion: json['DESCRIPCION'] ?? "",
    nombres: json['NOMBRES'] ?? "",
    apePaterno: json['APE_PATERNO'] ?? "",
    apeMaterno: json['APE_MATERNO'] ?? "",
    estado: json['ESTADO'] ?? 0,
    correo: json['CORREO'] ?? "",
    codigoPerfil: json['CODIGO_PERFIL'] ?? 0,
  );
}
