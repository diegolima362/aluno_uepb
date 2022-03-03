import 'dart:convert';

import '../../domain/entities/logged_user_info.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends LoggedUser implements LoggedUserInfo {
  UserModel({
    required String id,
    required String credentials,
  }) : super(
          id: id,
          credentials: credentials,
        );

  LoggedUser toLoggedUser() => this;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'credentials': credentials,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      credentials: map['credentials'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? id,
    String? credentials,
  }) {
    return UserModel(
      id: id ?? this.id,
      credentials: credentials ?? this.credentials,
    );
  }
}
