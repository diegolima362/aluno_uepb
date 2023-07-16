import 'dart:convert';

class User {
  final String username;
  final String password;

  User({
    required this.username,
    required this.password,
  });

  factory User.empty() {
    return User(
      username: '',
      password: '',
    );
  }

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }
}
