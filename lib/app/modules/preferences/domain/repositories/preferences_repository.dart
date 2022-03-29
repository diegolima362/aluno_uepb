import '../entities/preferences_entity.dart';
import '../types/types.dart';

abstract class IPreferencesRepository {
  Future<EitherUnit> setThemeMode(int val);

  Future<EitherInt> getThemeMode();

  Future<EitherUnit> clearDatabase();

  Future<EitherPreferences> getPreferences();

  Future<EitherUnit> updatePreferences(PreferencesEntity preferences);
}
