import 'package:isar/isar.dart';
import 'package:result_dart/result_dart.dart';

import '../../../shared/data/types/types.dart';
import '../data/datasources/profile_datasources.dart';
import '../models/profile.dart';
import 'schema.dart';

class ProfileIsarLocalDataSource implements ProfileLocalDataSource {
  final Isar db;

  ProfileIsarLocalDataSource(this.db);

  @override
  AsyncResult<Profile, AppException> fetchProfile() async {
    var data = await db.isarProfileModels.get(1);

    if (data == null) {
      return Failure(AppException('Profile not found'));
    }

    return Success(data.toDomain());
  }

  @override
  AsyncResult<Profile, AppException> save(Profile data) async {
    await db.writeTxn(() async {
      final toSave = IsarProfileModel.fromDomain(data);
      await db.isarProfileModels.put(toSave);
    });
    final response = await db.isarProfileModels.get(1);
    if (response == null) {
      return Failure(AppException('Profile not found'));
    }
    return Success(response.toDomain());
  }

  @override
  AsyncResult<Unit, AppException> clear() async {
    await db.writeTxn(() async {
      await db.isarProfileModels.clear();
    });

    return Success.unit();
  }
}
