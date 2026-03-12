class UserModel {
  final String username;
  final String role;
  final String token;

  UserModel({required this.username, required this.role, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      role: json['role'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'role': role, 'token': token};
  }
}
