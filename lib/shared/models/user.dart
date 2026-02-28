class User {
  final int id;
  final String username;
  final String password;
  final String name;
  final String email;
  final int isActive;
  final int role;

  const User({
    required this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.email,
    required this.isActive,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isActive: json['isActive'] ?? 0,
      role: json['role'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'email': email,
      'isActive': isActive,
      'role': role,
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? password,
    String? name,
    String? email,
    int? isActive,
    int? role,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
    );
  }
}
