import 'package:aluno_uepb/app/modules/preferences/infra/models/preferences_model.dart';

abstract class IPreferencesDatasource {
  Future<int> get themeMode;

  Future<PreferencesModel> get preferences;

  Future<void> updatePreferences(PreferencesModel preferences);

  Future<void> storeTheme(int value);

  Future<void> clearDatabase();
}
