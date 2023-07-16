import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/types/types.dart';
import '../../data/datasources/auth_datasources.dart';
import '../../models/user.dart';

class AuthSecureStorageLocalDataSource implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  AuthSecureStorageLocalDataSource(this._storage);

  @override
  Future<Result<User, AppException>> fetchUser() async {
    final user = await _storage.read(key: 'user');
    if (user == null) return Failure(AppException('User not found'));

    try {
      return Success(User.fromJson(user));
    } on TypeError {
      return Failure(AppException('User not found'));
    }
  }

  @override
  AsyncResult<Unit, AppException> save(User user) async {
    await _storage.write(key: 'user', value: user.toJson());
    return Success.unit();
  }

  @override
  AsyncResult<Unit, AppException> clear() async {
    await _storage.deleteAll();
    return Success.unit();
  }
}
