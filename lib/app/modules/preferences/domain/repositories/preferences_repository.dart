import '../types/types.dart';

abstract class IPreferencesRepository {
  Future<EitherUnit> setThemeMode(int val);

  Future<EitherInt> getThemeMode();

  Future<EitherUnit> clearDatabase();
}
