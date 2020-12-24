import 'package:flutter/foundation.dart';

class UserModel {
  final String id;
  final String password;
  final String photoURL;
  final String displayName;

  UserModel({
    @required this.id,
    @required this.password,
    this.photoURL,
    this.displayName,
  });

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    if (map == null || map.isEmpty)
      return null;
    else
      return UserModel(
        id: map['id'],
        password: map['password'],
        photoURL: map['photoURL'],
        displayName: map['displayName'],
      );
  }

  Map<dynamic, dynamic> toMap() => {
        'id': id,
        'password': password,
        'photoURL': photoURL,
        'displayName': displayName,
      };

  @override
  String toString() {
    return 'UserModel{id: $id, photoURL: $photoURL, displayName: $displayName}';
  }
}
