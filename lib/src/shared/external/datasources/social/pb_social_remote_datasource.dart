import 'package:pocketbase/pocketbase.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../modules/auth/models/user.dart';
import '../../../data/datasources/social_remote_datasource.dart';
import '../../../domain/models/app_exception.dart';
import '../../../domain/models/social_profile.dart';

class PocketBaseSocialRemoteDatasource implements SocialRemoteDatasource {
  final PocketBase pb;

  PocketBaseSocialRemoteDatasource({required this.pb});

  @override
  AsyncResult<SocialProfile, AppException> createUser(User user) async {
    final result = await signIn(user.username, user.password);
    if (result.isSuccess()) {
      return result;
    }

    try {
      await pb.collection("users").create(body: {
        'email': '+${user.username}@u.hub',
        'password': user.password,
        'passwordConfirm': user.password
      });
      if (!pb.authStore.isValid) {
        return AsyncResult.error(AppException('Error creating user'));
      }
      return Success(SocialProfile(
        name: pb.authStore.model['name'] ?? '',
        username: pb.authStore.model['username'] ?? '',
      ));
    } on ClientException catch (e) {
      return Failure(AppException(
        e.response['message'] ?? 'Error creating user',
      ));
    }
  }

  @override
  AsyncResult<SocialProfile, AppException> signIn(
      String username, String password) async {
    try {
      await pb
          .collection('users')
          .authWithPassword('+$username@u.hub', password);

      if (pb.authStore.isValid) {
        final model = (pb.authStore.model as RecordModel).data;
        return Success(SocialProfile(
          name: model['name'] ?? '',
          username: model['username'] ?? '',
        ));
      } else {
        return Failure(AppException('Failed to authenticate.'));
      }
    } on ClientException catch (e) {
      return Failure(AppException(
        e.response['message'] ?? 'Error creating user',
      ));
    }
  }
}
