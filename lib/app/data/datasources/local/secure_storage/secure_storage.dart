import 'package:flutter_secure_storage/flutter_secure_storage.dart';

late final FlutterSecureStorage _secureStorage;

FlutterSecureStorage get secureStorage => _secureStorage;

Future<void> initializeSecureStorage() async {
  _secureStorage = const FlutterSecureStorage();
}
