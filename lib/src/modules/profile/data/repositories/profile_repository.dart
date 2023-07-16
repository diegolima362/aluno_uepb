import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/datasources/remote_datasource.dart';
import '../../../../shared/data/types/types.dart';
import '../../models/profile.dart';
import '../datasources/profile_datasources.dart';

class ProfileRepository {
  final ProfileLocalDataSource _localDataSource;
  final AcademicRemoteDataSource _remoteDataSource;

  ProfileRepository(
    this._remoteDataSource,
    this._localDataSource,
  );

  AsyncResult<Profile, AppException> getProfile([bool refresh = false]) async {
    if (refresh == true) {
      final remote = await _remoteDataSource.fetchProfile();
      return await remote.fold(
        (data) async => await _localDataSource.save(data),
        (failure) => Failure(failure),
      );
    }

    final local = await _localDataSource.fetchProfile();
    if (local.isError()) {
      return getProfile(true);
    }
    return local;
  }

  Future<void> clear() async {
    await _localDataSource.clear();
  }
}
