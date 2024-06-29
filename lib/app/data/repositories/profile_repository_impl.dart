import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../../interactor/datasources/academic_datasource.dart';
import '../../interactor/models/profile.dart';
import '../../interactor/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final AppLocalDataSource _localDataSource;
  final AppRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  AsyncResult<Profile, AppException> fetchProfile() async {
    try {
      final profile = await _localDataSource.fetchProfile();
      if (profile == null) {
        return refreshProfile();
      }
      return Success(profile);
    } on AppException catch (e) {
      return Failure(e);
    }
  }

  @override
  AsyncResult<Profile, AppException> refreshProfile() async {
    try {
      final profile = await _remoteDataSource.fetchProfile();
      await _localDataSource.cacheProfile(profile);
      return Success(profile);
    } on AppException catch (e) {
      return Failure(e);
    }
  }
}
