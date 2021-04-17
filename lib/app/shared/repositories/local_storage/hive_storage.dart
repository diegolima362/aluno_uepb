import 'package:aluno_uepb/app/shared/auth/repositories/auth_repository.dart';
import 'package:aluno_uepb/app/shared/models/course_model.dart';
import 'package:aluno_uepb/app/shared/models/history_entry_model.dart';
import 'package:aluno_uepb/app/shared/models/profile_model.dart';
import 'package:aluno_uepb/app/shared/models/task_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'interfaces/local_storage_interface.dart';

@Injectable()
class HiveStorage implements ILocalStorage {
  static const PREFERENCES_BOX = 'preferences';
  static const COURSES_BOX = 'courses';
  static const TASKS_BOX = 'tasks';
  static const PROFILE_BOX = 'profile';
  static const HISTORY_BOX = 'history';

  @override
  int get darkAccentColorCode => Hive.box(PREFERENCES_BOX)
      .get('darkAccentColorCode', defaultValue: 0xfff0f0f0);

  @override
  int get lightAccentColorCode => Hive.box(PREFERENCES_BOX)
      .get('lightAccentColorCode', defaultValue: 0xff121212);

  @override
  Stream<int> get onDarkAccentChanged => Hive.box(PREFERENCES_BOX)
      .watch(key: 'darkAccentColorCode')
      .map((e) => e.value);

  @override
  Stream<int> get onLightAccentChanged => Hive.box(PREFERENCES_BOX)
      .watch(key: 'lightAccentColorCode')
      .map((e) => e.value);

  @override
  Stream<bool> get onThemeChanged => Hive.box(PREFERENCES_BOX)
      .watch(key: 'themeMode')
      .map((e) => e.value ?? false);

  @override
  bool get themeMode =>
      Hive.box(PREFERENCES_BOX).get('themeMode', defaultValue: false);

  @override
  Future<void> clearDatabase() async {
    print('> HiveStorage: clear data');

    await Hive.box(PREFERENCES_BOX).clear();
    await Hive.box(COURSES_BOX).clear();
    await Hive.box(TASKS_BOX).clear();
    await Hive.box(PROFILE_BOX).clear();
    await Hive.box(HISTORY_BOX).clear();

    print('> HiveStorage: data deleted');
  }

  @override
  Future<void> deleteTask(String id) async {
    await Hive.box(TASKS_BOX).delete(id);
  }

  @override
  Future<void> dispose() async {
    await Hive.box(PREFERENCES_BOX).close();
    await Hive.box(COURSES_BOX).close();
    await Hive.box(TASKS_BOX).close();
    await Hive.box(PROFILE_BOX).close();
    await Hive.box(HISTORY_BOX).close();
  }

  @override
  Future<List<CourseModel>> getCourses() async {
    final coursesBox = Hive.box(COURSES_BOX);

    final coursesMap = coursesBox.get('courses');

    if (coursesMap == null) {
      return null;
    } else {
      return _buildCourses(coursesMap);
    }
  }

  @override
  Future<List<HistoryEntryModel>> getHistory() async {
    final historyBox = Hive.box(HISTORY_BOX);

    final historyMap = historyBox.get('history');

    if (historyMap == null) {
      return null;
    } else {
      return _buildHistory(historyMap);
    }
  }

  @override
  Future<ProfileModel> getProfile() async {
    final box = Hive.box(PROFILE_BOX);

    final data = box.get('profile');

    if (data == null) {
      return null;
    } else {
      return ProfileModel.fromMap(data);
    }
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    final tasksBox = await Hive.openBox(TASKS_BOX);
    final tasksMap = <Map>[];
    tasksBox.toMap().forEach((key, value) => tasksMap.add(value));
    return _buildTasks(tasksMap);
  }

  ValueListenable<Box> onTasksChanged() => Hive.box(TASKS_BOX).listenable();

  Future<void> saveCourses(List<CourseModel> courses) async {
    print('> HiveStorage.saveCourses');

    final box = Hive.box(COURSES_BOX);

    await box.clear();

    final data = courses.map((e) => e.toMap()).toList();

    await box.put(COURSES_BOX, data);
  }

  @override
  Future<void> saveHistory(List<HistoryEntryModel> history) async {
    print('> HiveStorage.saveHistory');

    final box = Hive.box(HISTORY_BOX);

    await box.clear();

    final data = history.map((e) => e.toMap()).toList();

    await box.put(HISTORY_BOX, data);
  }

  Future<void> saveProfile(ProfileModel profile) async {
    final box = Hive.box(PROFILE_BOX);

    await box.clear();

    final data = profile.toMap();

    await box.put(PROFILE_BOX, data);
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    await Hive.box(TASKS_BOX).put(task.id, task.toMap());
  }

  @override
  Future<void> setDarkAccentColorCode(int value) async {
    await Hive.box(PREFERENCES_BOX).put('darkAccentColorCode', value);
  }

  @override
  Future<void> setLightAccentColorCode(int value) async {
    await Hive.box(PREFERENCES_BOX).put('lightAccentColorCode', value);
  }

  @override
  Future<void> setThemeMode(bool value) async {
    await Hive.box(PREFERENCES_BOX).put('themeMode', value);
  }

  List<CourseModel> _buildCourses(List<dynamic> data) {
    return data.map((e) => CourseModel.fromMap(e)).toList();
  }

  List<HistoryEntryModel> _buildHistory(List<dynamic> data) {
    return data.map((e) => HistoryEntryModel.fromMap(e)).toList();
  }

  List<TaskModel> _buildTasks(List<dynamic> data) {
    return data.map((e) => TaskModel.fromMap(e)).toList();
  }

  static Future<void> initDatabase() async {
    await Hive.openBox(AuthRepository.LOGIN_BOX);
    await Hive.openBox(PREFERENCES_BOX);
    await Hive.openBox(COURSES_BOX);
    await Hive.openBox(TASKS_BOX);
    await Hive.openBox(PROFILE_BOX);
    await Hive.openBox(HISTORY_BOX);
  }
}
