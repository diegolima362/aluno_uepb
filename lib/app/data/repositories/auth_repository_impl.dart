import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../../interactor/datasources/academic_datasource.dart';
import '../../interactor/models/user.dart';
import '../../interactor/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AppRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  AsyncResult<User, AppException> fetchCurrentUser() async {
    final userString = await _localDataSource.fetchToken();

    if (userString != null) {
      final user = User.fromJson(userString);
      _remoteDataSource.setToken(userString);
      return Success(user);
    }
    return Failure(AppException('No user logged in'));
  }

  @override
  AsyncResult<User, AppException> login(
      String username, String password) async {
    try {
      final user = await _remoteDataSource.login(username, password);
      await _localDataSource.cacheToken(user.toJson());
      return Success(user);
    } on AppException catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearToken();
    _remoteDataSource.clearToken();
  }
}
