import 'dart:async';

import 'package:aluno_uepb/app/shared/auth/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'interfaces/local_storage_interface.dart';

part 'hive_storage.g.dart';

@Injectable()
class HiveStorage implements ILocalStorage {
  static const PREFERENCES_BOX = 'preferences';
  static const COURSES_BOX = 'courses';
  static const TASKS_BOX = 'tasks';
  static const PROFILE_BOX = 'profile';
  static const HISTORY_BOX = 'history';

  static const int _defaultDarkAccent = 0xfff2f2f7;
  static const int _defaultAccent = 0xff1c1c1e;

  int get darkAccentColorCode => Hive.box(PREFERENCES_BOX)
      .get('darkAccentColorCode', defaultValue: _defaultDarkAccent);

  int get lightAccentColorCode => Hive.box(PREFERENCES_BOX)
      .get('lightAccentColorCode', defaultValue: _defaultAccent);

  Stream<int> get onDarkAccentChanged => Hive.box(PREFERENCES_BOX)
      .watch(key: 'darkAccentColorCode')
      .map((e) => e.value ?? _defaultDarkAccent);

  Stream<int> get onLightAccentChanged => Hive.box(PREFERENCES_BOX)
      .watch(key: 'lightAccentColorCode')
      .map((e) => e.value ?? _defaultAccent);

  Stream<bool> get onThemeChanged => Hive.box(PREFERENCES_BOX)
      .watch(key: 'themeMode')
      .map((e) => e.value ?? false);

  bool get themeMode =>
      Hive.box(PREFERENCES_BOX).get('themeMode', defaultValue: false);

  Future<void> clearDatabase() async {
    print('> HiveStorage: clear data');
    await Future.wait([
      Hive.box(PREFERENCES_BOX).clear(),
      Hive.box(COURSES_BOX).clear(),
      Hive.box(TASKS_BOX).clear(),
      Hive.box(PROFILE_BOX).clear(),
      Hive.box(HISTORY_BOX).clear(),
    ]);
    print('> HiveStorage: data deleted');
  }

  Future<void> deleteTask(String id) async {
    await Hive.box(TASKS_BOX).delete(id);
  }

  Future<void> dispose() async {
    await Hive.box(PREFERENCES_BOX).close();
    await Hive.box(COURSES_BOX).close();
    await Hive.box(TASKS_BOX).close();
    await Hive.box(PROFILE_BOX).close();
    await Hive.box(HISTORY_BOX).close();
  }

  FutureOr<List<Map<String, dynamic>>?> getCourses() {
    final coursesBox = Hive.box(COURSES_BOX);

    final coursesMap = coursesBox.get('courses');

    if (coursesMap == null) {
      return null;
    } else {
      return coursesMap;
    }
  }

  FutureOr<List<Map<String, dynamic>>?> getHistory() {
    final historyBox = Hive.box(HISTORY_BOX);

    final historyMap = historyBox.get('history');

    if (historyMap == null) {
      return null;
    } else {
      return historyMap;
    }
  }

  FutureOr<Map<String, dynamic>?> getProfile() {
    final box = Hive.box(PROFILE_BOX);
    final data = box.get('profile');
    if (data == null) {
      return null;
    } else {
      return data;
    }
  }

  FutureOr<List<Map<String, dynamic>>> getTasks() {
    final tasksBox = Hive.box(TASKS_BOX);
    final tasksMap = <Map<String, dynamic>>[];
    tasksBox.values.forEach((value) => tasksMap.add(value));
    return tasksMap;
  }

  ValueListenable<Box> onTasksChanged() => Hive.box(TASKS_BOX).listenable();

  Future<void> saveCourses(List<Map<String, dynamic>> courses) async {
    final box = Hive.box(COURSES_BOX);
    await box.clear();
    await box.put(COURSES_BOX, courses);
  }

  Future<void> saveHistory(List<Map<String, dynamic>> history) async {
    final box = Hive.box(HISTORY_BOX);
    await box.clear();
    await box.put(HISTORY_BOX, history);
  }

  Future<void> saveProfile(Map<String, dynamic> profile) async {
    final box = Hive.box(PROFILE_BOX);
    await box.clear();
    await box.put(PROFILE_BOX, profile);
  }

  Future<void> saveTask(Map<String, dynamic> task) async {
    await Hive.box(TASKS_BOX).put(task['id'], task);
  }

  Future<void> setDarkAccentColorCode(int value) async {
    await Hive.box(PREFERENCES_BOX).put('darkAccentColorCode', value);
  }

  Future<void> setLightAccentColorCode(int value) async {
    await Hive.box(PREFERENCES_BOX).put('lightAccentColorCode', value);
  }

  Future<void> setThemeMode(bool value) async {
    await Hive.box(PREFERENCES_BOX).put('themeMode', value);
  }

  static Future<void> initDatabase() async {
    await Future.wait([
      Hive.openBox(PREFERENCES_BOX),
      Hive.openBox(COURSES_BOX),
      Hive.openBox(TASKS_BOX),
      Hive.openBox(PROFILE_BOX),
      Hive.openBox(HISTORY_BOX),
    ]);
  }
}
