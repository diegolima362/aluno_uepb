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
}
