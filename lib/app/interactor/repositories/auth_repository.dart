import 'dart:async';

import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../models/user.dart';

abstract class AuthRepository {
  AsyncResult<User, AppException> login(String username, String password);

  AsyncResult<User, AppException> fetchCurrentUser();

  Future<void> logout();
}
