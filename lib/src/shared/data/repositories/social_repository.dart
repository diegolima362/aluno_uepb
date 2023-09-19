import 'package:result_dart/result_dart.dart';

import '../../../modules/auth/models/user.dart';
import '../../domain/models/app_exception.dart';
import '../../domain/models/social_profile.dart';
import '../datasources/social_remote_datasource.dart';

class SocialRepository {
  final SocialRemoteDatasource _remote;

  SocialRepository(this._remote);

  AsyncResult<SocialProfile, AppException> createUser(User user) async {
    final result = await _remote.createUser(user);
    return result;
  }

  AsyncResult<SocialProfile, AppException> signIn(
    String username,
    String password,
  ) {
    return _remote.signIn(username, password);
  }
}
