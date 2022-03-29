import 'package:aluno_uepb/app/core/external/drivers/shared_prefs.dart';
import 'package:aluno_uepb/app/modules/auth/domain/errors/errors.dart';
import 'package:aluno_uepb/app/modules/profile/infra/models/models.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/errors/errors.dart';
import '../../domain/repositories/academic_repository.dart';
import '../../domain/types/types.dart';
import '../datasources/profile_datasource.dart';

class ProfileRepository implements IProfileRepository {
  final IProfileLocalDatasource localDatasource;
  final IProfileRemoteDatasource remoteDatasource;
  final SharedPrefs prefsStorage;

  Option<ProfileModel> profile = none();

  ProfileRepository(
    this.localDatasource,
    this.remoteDatasource,
    this.prefsStorage,
  );

  Future<bool> get updated async => DateTime.now()
      .add(const Duration(hours: 1))
      .isAfter(await prefsStorage.getLastProfileUpdate());

  @override
  Future<EitherProfile> getProfile({bool cached = true}) async {
    Option<ProfileModel> p = none();

    if (cached) {
      if (profile.isSome()) {
        return Right(profile);
      } else {
        try {
          final result = (await localDatasource.getProfile());
          p = result;
          profile = result;
        } on ProfileFailure catch (e) {
          return Left(e);
        }
      }
    }

    if (p.isNone() || !await updated) {
      try {
        if (p.isNone()) {
          final result = await remoteDatasource.getProfile();

          if (result.isSome()) {
            await localDatasource.saveProfile(result.toNullable()!);
          }

          p = result;
          profile = result;

          return Right(result);
        } else {
          remoteDatasource.getProfile().then(
            (r) async {
              if (r.isSome()) {
                await localDatasource.saveProfile(r.toNullable()!);
                profile = r;
              }
            },
          );
        }

        await prefsStorage.setLastProfileUpdate(DateTime.now());
      } on AuthFailure catch (e) {
        return Left(GetProfileError(message: e.message));
      } on ProfileFailure catch (e) {
        return Left(e);
      }
    }

    return Right(p);
  }
}
