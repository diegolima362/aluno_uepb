import 'package:fpdart/fpdart.dart';

import '../models/models.dart';

abstract class IProfileDatasource {
  Future<Option<ProfileModel>> getProfile();
}

abstract class IProfileLocalDatasource extends IProfileDatasource {
  Future<Unit> saveProfile(ProfileModel profile);
}

abstract class IProfileRemoteDatasource extends IProfileDatasource {}
