class User {
  final int idUsuario;
  final String login;
  final String apellidosyNombres;
  final String correoInstitucional;
  final String numeroDocumento;

  const User({
    required this.idUsuario,
    required this.login,
    required this.apellidosyNombres,
    required this.correoInstitucional,
    required this.numeroDocumento,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUsuario: json['idUsuario'] ?? 0,
      login: json['login'] ?? '',
      apellidosyNombres: json['apellidosyNombres'] ?? '',
      correoInstitucional: json['correoInstitucional'] ?? '',
      numeroDocumento: json['numeroDocumento'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'login': login,
      'apellidosyNombres': apellidosyNombres,
      'correoInstitucional': correoInstitucional,
      'numeroDocumento': numeroDocumento,
    };
  }

  User copyWith({
    int? idUsuario,
    String? login,
    String? apellidosyNombres,
    String? correoInstitucional,
    String? numeroDocumento,
  }) {
    return User(
      idUsuario: idUsuario ?? this.idUsuario,
      login: login ?? this.login,
      apellidosyNombres: apellidosyNombres ?? this.apellidosyNombres,
      correoInstitucional: correoInstitucional ?? this.correoInstitucional,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
    );
  }
}
