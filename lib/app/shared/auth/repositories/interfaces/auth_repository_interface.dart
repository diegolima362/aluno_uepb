import 'package:flutter_modular/flutter_modular.dart';

abstract class IAuthRepository implements Disposable {
  Map<String, dynamic>? get currentUser;

  Future<void> clearAuthData();

  Future<void> storeAuthData(Map<String, dynamic> data);
}
