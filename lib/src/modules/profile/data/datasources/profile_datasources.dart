import 'package:result_dart/result_dart.dart';

import '../../../../shared/domain/models/app_exception.dart';
import '../../domain/models/profile.dart';

abstract class ProfileLocalDataSource {
  AsyncResult<Profile, AppException> fetchProfile();
  AsyncResult<Profile, AppException> save(Profile data);
  AsyncResult<Unit, AppException> clear();
}
