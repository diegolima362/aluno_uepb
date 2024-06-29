import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../interactor/datasources/academic_datasource.dart';

const _secureStorageKey = 'token';

class AuthSecureStorageLocalDataSource implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  AuthSecureStorageLocalDataSource(this._storage);

  @override
  Future<String?> fetchToken() async {
    final token = await _storage.read(key: _secureStorageKey);
    if (token == null) {
      return null;
    }

    return token;
  }

  @override
  Future<void> cacheToken(String token) async {
    await _storage.write(key: _secureStorageKey, value: token);
  }

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: _secureStorageKey);
  }
}
