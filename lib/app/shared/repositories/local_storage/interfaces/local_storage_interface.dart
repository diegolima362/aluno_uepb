import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';

abstract class ILocalStorage implements Disposable {
  Future<List<CourseModel>> getCourses({bool ignoreLocalData});

  Future<ProfileModel> getProfile({bool ignoreLocalData});

  Stream<bool> get onThemeChanged;

  bool get isDarkMode;

  Future<void> setDarkMode(bool isDark);

  Future<List<TaskModel>> getTasks();

  Future<void> addTask(TaskModel task);

  Future<void> deleteTask(TaskModel task);

  ValueListenable<Box> onTasksChanged();

  Future<void> clearDatabase();
}
