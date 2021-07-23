import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../interfaces/auth_repository_interface.dart';

class SharedPreferencesRepository implements IAuthRepository {
  static SharedPreferences? _storage;

  SharedPreferencesRepository() {
    init();
  }

  static Future<void> init() async {
    _storage = await SharedPreferences.getInstance();
  }

  Future<void> clearAuthData() async {
    if (_storage == null) await init();
    if ((_storage!.getKeys().contains('user'))) await _storage?.remove('user');
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    if (_storage == null) await init();
    final data = _storage!.getString('user');
    return data == null || data.isEmpty ? null : json.decode(data);
  }

  Future<void> storeAuthData(Map<String, dynamic> data) async {
    if (_storage == null) await init();
    final parsedData = json.encode(data);
    await _storage!.setString('user', parsedData);
  }
}
