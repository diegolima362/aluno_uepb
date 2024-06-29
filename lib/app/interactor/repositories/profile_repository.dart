import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../models/profile.dart';

abstract class ProfileRepository {
  AsyncResult<Profile, AppException> fetchProfile();

  AsyncResult<Profile, AppException> refreshProfile();
}
