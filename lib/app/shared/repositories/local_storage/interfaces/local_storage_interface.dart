import 'dart:async';

abstract class ILocalStorage {
  int get lightAccentColorCode;

  int get darkAccentColorCode;

  bool get themeMode;

  bool get backgroundTaskActivated;

  Stream<int> get onLightAccentChanged;

  Stream<int> get onDarkAccentChanged;

  Stream<bool> get onThemeChanged;

  FutureOr<Map<String, dynamic>?> getProfile();

  FutureOr<List<Map<String, dynamic>>?> getTasks();

  FutureOr<List<Map<String, dynamic>>?> getHistory();

  FutureOr<List<Map<String, dynamic>>?> getCourses();

  FutureOr<String?> getAlerts();

  Future<void> setThemeMode(bool value);

  Future<void> setLightAccentColorCode(int value);

  Future<void> setDarkAccentColorCode(int value);

  Future<void> setBackgroundTaskActivated(bool value);

  Future<void> saveTask(Map<String, dynamic> task);

  Future<void> saveProfile(Map<String, dynamic> profile);

  Future<void> saveHistory(List<Map<String, dynamic>> history);

  Future<void> saveCourses(List<Map<String, dynamic>> courses);

  Future<void> saveAlerts(String alerts);

  Future<void> dispose();

  Future<void> deleteTask(String id);

  Future<void> deleteAlerts();

  Future<void> clearDatabase();
}
