import 'package:aluno_uepb/app/shared/models/course_model.dart';
import 'package:aluno_uepb/app/shared/models/history_entry_model.dart';
import 'package:aluno_uepb/app/shared/models/profile_model.dart';
import 'package:aluno_uepb/app/shared/models/task_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';

abstract class ILocalStorage implements Disposable {
  int get darkAccentColorCode;

  int get lightAccentColorCode;

  Stream<int> get onDarkAccentChanged;

  Stream<int> get onLightAccentChanged;

  Stream<bool> get onThemeChanged;

  bool get themeMode;

  Future<void> clearDatabase();

  Future<void> deleteTask(String id);

  Future<List<CourseModel>> getCourses();

  Future<List<HistoryEntryModel>> getHistory();

  Future<ProfileModel> getProfile();

  Future<List<TaskModel>> getTasks();

  ValueListenable<Box> onTasksChanged();

  Future<void> saveCourses(List<CourseModel> courses);

  Future<void> saveHistory(List<HistoryEntryModel> history);

  Future<void> saveProfile(ProfileModel profile);

  Future<void> saveTask(TaskModel task);

  Future<void> setDarkAccentColorCode(int value);

  Future<void> setLightAccentColorCode(int value);

  Future<void> setThemeMode(bool value);
}
