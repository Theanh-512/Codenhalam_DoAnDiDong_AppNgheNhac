class UserModel {
  final String username;
  final String role;
  final String token;
  final String? email;

  UserModel({
    required this.username,
    required this.role,
    required this.token,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      role: json['role'],
      token: json['token'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'role': role, 'token': token, 'email': email};
  }
}
