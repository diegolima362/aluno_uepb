import 'package:flutter/foundation.dart';

class UserModel {
  final String id;
  final String password;
  final String photoURL;
  final String displayName;
  final DateTime accessed;

  final bool logged;

  UserModel({
    @required this.id,
    @required this.password,
    @required this.logged,
    this.accessed,
    this.photoURL,
    this.displayName,
  });

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    if (map == null || map.isEmpty)
      return null;
    else {
      String dateString =
          map['accessed'] ?? DateTime.now().microsecondsSinceEpoch.toString();
      final _date =
          DateTime.fromMicrosecondsSinceEpoch(int.tryParse(dateString));

      return UserModel(
        id: map['id'],
        password: map['password'],
        photoURL: map['photoURL'],
        displayName: map['displayName'],
        logged: map['logged'],
        accessed: _date,
      );
    }
  }

  Map<dynamic, dynamic> toMap() => {
        'id': id,
        'password': password,
        'photoURL': photoURL,
        'displayName': displayName,
        'logged': logged,
        'accessed': accessed,
      };

  @override
  String toString() {
    return 'UserModel{id: $id, photoURL: $photoURL, displayName: $displayName, logged: $logged, accessed: $accessed}';
  }
}
