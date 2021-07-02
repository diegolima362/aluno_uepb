import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../interfaces/auth_repository_interface.dart';

class FlutterSecureStorageRepository implements IAuthRepository {
  late final FlutterSecureStorage storage;

  FlutterSecureStorageRepository() {
    storage = FlutterSecureStorage();
  }

  Future<void> clearAuthData() async {
    if (await storage.containsKey(key: 'user')) {
      await storage.delete(key: 'user');
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final data = await storage.read(key: 'user');
    return data == null ? null : json.decode(data);
  }

  Future<void> storeAuthData(Map<String, dynamic> data) async {
    final parsedData = json.encode(data);
    await storage.write(key: 'user', value: parsedData);
  }
}
