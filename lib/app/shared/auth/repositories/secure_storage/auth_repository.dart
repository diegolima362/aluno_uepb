import 'dart:convert';

import 'package:flutter_modular/flutter_modular.dart';

import 'auth_repository_interface.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'auth_repository.g.dart';

@Injectable()
class AuthRepository implements IAuthRepository {
  late final FlutterSecureStorage storage;

  AuthRepository() {
    storage = new FlutterSecureStorage();
  }

  Future<void> clearAuthData() async => await storage.deleteAll();

  Map<String, dynamic>? get currentUser {
    storage
        .read(key: 'user')
        .then((value) => value == null ? null : json.decode(value));
  }

  Future<void> storeAuthData(Map<String, dynamic> data) async {
    final parsedData = json.encode(data);
    await storage.write(key: 'user', value: parsedData);
  }

  void dispose() {}
}
