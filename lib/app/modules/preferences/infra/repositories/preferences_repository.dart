import 'package:aluno_uepb/app/modules/preferences/domain/entities/preferences_entity.dart';
import 'package:aluno_uepb/app/modules/preferences/infra/models/preferences_model.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/erros/erros.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../../domain/types/types.dart';
import '../datasources/preferences_datasource.dart';

class PreferencesRepository implements IPreferencesRepository {
  final IPreferencesDatasource datasource;

  PreferencesRepository(this.datasource);

  @override
  Future<EitherInt> getThemeMode() async {
    try {
      return Right(await datasource.themeMode);
    } on PreferencesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherPreferences> getPreferences() async {
    try {
      return Right(await datasource.preferences);
    } on PreferencesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> setThemeMode(int val) async {
    try {
      await datasource.storeTheme(val);
      return const Right(unit);
    } on PreferencesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> clearDatabase() async {
    try {
      await datasource.clearDatabase();
      return const Right(unit);
    } on PreferencesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> updatePreferences(PreferencesEntity preferences) async {
    final _preferences = PreferencesModel(
      themeIndex: preferences.themeMode.index,
      allowNotifications: preferences.allowNotifications,
      allowAutoDownload: preferences.allowAutoDownload,
      seedColor: preferences.seedColor,
    );
    await datasource.updatePreferences(_preferences);
    return const Right(unit);
  }
}
