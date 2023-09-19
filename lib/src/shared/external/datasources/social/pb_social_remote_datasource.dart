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
    try {
      await pb
          .collection('users')
          .authWithPassword('+${user.username}@u.hub', user.password);

      if (pb.authStore.isValid) {
        final model = (pb.authStore.model as RecordModel).data;
        return Success(SocialProfile(
          name: model['name'] ?? '',
          username: model['username'] ?? '',
        ));
      }
    } on ClientException catch (e) {
      final message = e.response['message'] ?? 'Error creating user';
      if (e.response['message'] != 'Failed to authenticate.') {
        return Failure(AppException(message));
      }
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
      print(e);
      return Failure(AppException(
        e.response['message'] ?? 'Error creating user',
      ));
    }
  }
}
