import 'package:result_dart/result_dart.dart';

import '../../../modules/auth/models/user.dart';
import '../../domain/models/app_exception.dart';
import '../../domain/models/social_profile.dart';

abstract class SocialRemoteDatasource {
  AsyncResult<SocialProfile, AppException> createUser(User user);
}
