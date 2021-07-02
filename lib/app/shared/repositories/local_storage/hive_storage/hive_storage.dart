import 'dart:async';

import 'package:hive/hive.dart';

import '../interfaces/local_storage_interface.dart';

class HiveStorage implements ILocalStorage {
  static const ALERTS_BOX = 'alerts';
  static const COURSES_BOX = 'courses';
  static const HISTORY_BOX = 'history';
  static const PREFERENCES_BOX = 'preferences';
  static const PROFILE_BOX = 'profile';
  static const TASKS_BOX = 'tasks';

  static const STORAGE_DIR = 'alunoUEPB/data';

  static const int _defaultDarkAccent = 0xfff2f2f7;
  static const int _defaultAccent = 0xff1c1c1e;

  static Future<void> initDatabase() async {
    await Future.wait([
      Hive.openBox(PREFERENCES_BOX),
      Hive.openBox(COURSES_BOX),
      Hive.openBox(TASKS_BOX),
      Hive.openBox(PROFILE_BOX),
      Hive.openBox(HISTORY_BOX),
      Hive.openBox(ALERTS_BOX),
    ]);
  }

  int get lightAccentColorCode => Hive.box(PREFERENCES_BOX)
      .get('lightAccentColorCode', defaultValue: _defaultAccent);

  int get darkAccentColorCode => Hive.box(PREFERENCES_BOX)
      .get('darkAccentColorCode', defaultValue: _defaultDarkAccent);

  bool get themeMode =>
      Hive.box(PREFERENCES_BOX).get('themeMode', defaultValue: false);

  bool get backgroundTaskActivated => Hive.box(PREFERENCES_BOX)
      .get('backgroundTaskActivated', defaultValue: false);

  Stream<int> get onLightAccentChanged => Hive.box(PREFERENCES_BOX)
      .watch(key: 'lightAccentColorCode')
      .map((e) => e.value ?? _defaultAccent);

  Stream<int> get onDarkAccentChanged => Hive.box(PREFERENCES_BOX)
      .watch(key: 'darkAccentColorCode')
      .map((e) => e.value ?? _defaultDarkAccent);

  Stream<bool> get onThemeChanged => Hive.box(PREFERENCES_BOX)
      .watch(key: 'themeMode')
      .map((e) => e.value ?? false);

  FutureOr<Map<String, dynamic>?> getProfile() {
    final box = Hive.box(PROFILE_BOX);
    final data = box.get('profile');
    if (data == null) {
      return null;
    } else {
      return (data as Map<dynamic, dynamic>)
          .map((key, value) => MapEntry(key as String, value));
    }
  }

  FutureOr<List<Map<String, dynamic>>?> getTasks() {
    return Hive.box(TASKS_BOX)
        .values
        .map((e) => (e as Map<dynamic, dynamic>)
            .map((k, v) => MapEntry(k as String, v)))
        .toList();
  }

  FutureOr<List<Map<String, dynamic>>?> getHistory() {
    final historyBox = Hive.box(HISTORY_BOX);
    final historyMap = historyBox.get(HISTORY_BOX);
    if (historyMap == null) {
      return null;
    } else {
      return (historyMap as List<dynamic>)
          .map((e) => (e as Map<dynamic, dynamic>)
              .map((k, v) => MapEntry(k as String, v)))
          .toList();
    }
  }

  FutureOr<List<Map<String, dynamic>>?> getCourses() async {
    if (!Hive.isBoxOpen(COURSES_BOX)) await Hive.openBox(COURSES_BOX);
    final coursesBox = Hive.box(COURSES_BOX);
    final coursesMap = coursesBox.get('courses');
    if (coursesMap == null) {
      return null;
    } else {
      return (coursesMap as List<dynamic>)
          .map((e) => (e as Map<dynamic, dynamic>)
              .map((k, v) => MapEntry(k as String, v)))
          .toList();
    }
  }

  FutureOr<String?> getAlerts() async {
    if (!Hive.isBoxOpen(ALERTS_BOX)) await Hive.openBox(COURSES_BOX);
    return Hive.box(ALERTS_BOX).get(ALERTS_BOX, defaultValue: '');
  }

  Future<void> setThemeMode(bool value) async {
    await Hive.box(PREFERENCES_BOX).put('themeMode', value);
  }

  Future<void> setLightAccentColorCode(int value) async {
    await Hive.box(PREFERENCES_BOX).put('lightAccentColorCode', value);
  }

  Future<void> setDarkAccentColorCode(int value) async {
    await Hive.box(PREFERENCES_BOX).put('darkAccentColorCode', value);
  }

  Future<void> setBackgroundTaskActivated(bool value) async {
    await Hive.box(PREFERENCES_BOX).put('backgroundTaskActivated', value);
  }

  Future<void> saveTask(Map<String, dynamic> task) async {
    await Hive.box(TASKS_BOX).put(task['id'], task);
  }

  Future<void> saveProfile(Map<String, dynamic> profile) async {
    final box = Hive.box(PROFILE_BOX);
    await box.clear();
    await box.put(PROFILE_BOX, profile);
  }

  Future<void> saveHistory(List<Map<String, dynamic>> history) async {
    final box = Hive.box(HISTORY_BOX);
    await box.clear();
    await box.put(HISTORY_BOX, history);
  }

  Future<void> saveCourses(List<Map<String, dynamic>> courses) async {
    if (!Hive.isBoxOpen(COURSES_BOX)) await Hive.openBox(COURSES_BOX);
    final box = Hive.box(COURSES_BOX);
    await box.clear();
    await box.put(COURSES_BOX, courses);
  }

  Future<void> saveAlerts(String alerts) async {
    await Hive.box(ALERTS_BOX).put(ALERTS_BOX, alerts);
  }

  Future<void> dispose() async {
    await Future.wait([
      Hive.box(PREFERENCES_BOX).close(),
      Hive.box(COURSES_BOX).close(),
      Hive.box(TASKS_BOX).close(),
      Hive.box(PROFILE_BOX).close(),
      Hive.box(HISTORY_BOX).close(),
      Hive.box(ALERTS_BOX).close(),
    ]);
  }

  Future<void> deleteTask(String id) async =>
      await Hive.box(TASKS_BOX).delete(id);

  Future<void> deleteAlerts() async => await Hive.box(ALERTS_BOX).clear();

  Future<void> clearDatabase() async {
    print('> HiveStorage: clear data');
    await Future.wait([
      Hive.box(PREFERENCES_BOX).clear(),
      Hive.box(COURSES_BOX).clear(),
      Hive.box(TASKS_BOX).clear(),
      Hive.box(PROFILE_BOX).clear(),
      Hive.box(HISTORY_BOX).clear(),
      Hive.box(ALERTS_BOX).clear(),
    ]);
    print('> HiveStorage: data deleted');
  }
}
