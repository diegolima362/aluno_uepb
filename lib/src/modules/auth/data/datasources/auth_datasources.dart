import 'package:result_dart/result_dart.dart';

import '../../../../shared/domain/models/app_exception.dart';
import '../../models/user.dart';

abstract class AuthLocalDataSource {
  AsyncResult<User, AppException> fetchUser();
  AsyncResult<Unit, AppException> save(User user);
  AsyncResult<Unit, AppException> clear();
}
