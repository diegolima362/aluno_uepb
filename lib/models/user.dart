import 'package:flutter/foundation.dart';

class User {
  final String user;
  final String password;

  User({@required this.user, @required this.password});

  factory User.fromMap(Map<dynamic, dynamic> map) =>
      User(user: map['user'], password: map['password']);

  Map toMap() => {'user': this.user, 'password': this.password};

  Map<String, String> toLoginMap() =>
      {'nome_usuario': this.user, 'senha_usuario': this.password};

  @override
  String toString() => 'user: ${this.user} password: ${this.password}';
}
