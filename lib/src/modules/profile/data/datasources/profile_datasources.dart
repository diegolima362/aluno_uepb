import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/types/types.dart';
import '../../models/profile.dart';

abstract class ProfileLocalDataSource {
  AsyncResult<Profile, AppException> fetchProfile();
  AsyncResult<Profile, AppException> save(Profile data);
  AsyncResult<Unit, AppException> clear();
}
