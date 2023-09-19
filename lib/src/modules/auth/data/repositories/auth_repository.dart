import 'dart:async';

import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/datasources/remote_datasource.dart';
import '../../../../shared/domain/models/app_exception.dart';
import '../../models/user.dart';
import '../datasources/auth_datasources.dart';

class AuthRepository {
  final AuthLocalDataSource _local;
  final AcademicRemoteDataSource _remote;

  AuthRepository(this._local, this._remote);

  User? _currentUser;

  User? get currentUser => _currentUser;

  AsyncResult<User, AppException> fetchCurrentUser() async {
    final result = await _local.fetchUser();

    return result.fold(
      (s) {
        _currentUser = s;
        _remote.setUser(s);

        return Success(s);
      },
      (f) => Failure(f),
    );
  }

  AsyncResult<User, AppException> signIn(String user, String password) async {
    final result = await _remote.signInWithUserAndPassword(user, password);

    return result.fold(
      (s) async {
        _currentUser = s;
        _remote.setUser(s);
        await _local.save(s);

        return Success(s);
      },
      (f) => Failure(f),
    );
  }

  Future<Unit> signOut() async {
    _currentUser = null;
    await _local.clear();
    return unit;
  }
}
