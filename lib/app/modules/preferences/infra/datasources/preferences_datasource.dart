abstract class IPreferencesDatasource {
  Future<int> get themeMode;

  Future<void> storeTheme(int value);

  Future<void> clearDatabase();
}
