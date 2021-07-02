class UserModel {
  final String id;
  final String password;
  final String? photoURL;
  final String? displayName;
  final bool logged;

  UserModel({
    required this.id,
    required this.password,
    required this.logged,
    this.photoURL,
    this.displayName,
  });

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      id: map['id'],
      password: map['password'],
      photoURL: map['photoURL'],
      displayName: map['displayName'],
      logged: map['logged'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'password': password,
        'photoURL': photoURL,
        'displayName': displayName,
        'logged': logged,
      };

  @override
  String toString() {
    return 'UserModel{id: $id, photoURL: $photoURL, displayName: $displayName, logged: $logged}';
  }
}
