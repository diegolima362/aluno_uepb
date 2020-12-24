import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/repositories/data_respository/interfaces/data_repository_interface.dart';
import 'package:aluno_uepb/app/utils/connection_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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

  ProfileModel _profile;
  List<CourseModel> _courses;

  static Future<void> initDatabase() async {
    await Hive.openBox(PREFERENCES_BOX);
    await Hive.openBox(COURSES_BOX);
    await Hive.openBox(TASKS_BOX);
    await Hive.openBox(PROFILE_BOX);
  }

  @override
  Future<ProfileModel> getProfile({bool ignoreLocalData: false}) async {
    if (!ignoreLocalData) {
      if (_profile != null) {
        print('> HiveStorage: returning cached data');
        return _profile;
      }
      _profile = _getLocalProfileData();

      if (_profile != null) {
        print('> HiveStorage: returning local data');
        return _profile;
      }
    }

    try {
      _profile = await _getRemoteProfileData();
    } catch (e) {
      rethrow;
    }

    print('> HiveStorage: returning remote data');
    return _profile;
  }

  ProfileModel _getLocalProfileData() {
    final coursesBox = Hive.box(COURSES_BOX);

    final data = coursesBox.get('profile');

    if (data == null) {
      return null;
    } else {
      return ProfileModel.fromMap(data);
    }
  }

  Future<ProfileModel> _getRemoteProfileData() async {
    try {
      if (!await CheckConnection.checkConnection()) {
        throw PlatformException(
          message: 'Sem conexão com a internet',
          code: 'error_connection',
        );
      }
    } catch (e) {
      rethrow;
    }

    final repository = Modular.get<IDataRepository>();

    try {
      _profile = await repository.getProfile();
      _saveProfile(_profile);
    } catch (e) {
      rethrow;
    }

    return _profile;
  }

  Future<void> _saveProfile(ProfileModel profile) async {
    final box = Hive.box(PROFILE_BOX);

    await box.clear();

    final data = profile.toMap();

    await box.put('profile', data);
  }

  @override
  Future<List<CourseModel>> getCourses({bool ignoreLocalData: false}) async {
    if (!ignoreLocalData) {
      if (_courses != null) {
        print('> HiveStorage: returning cached data');
        return _courses;
      }
      _courses = _getLocalCoursesData();

      if (_courses != null) {
        print('> HiveStorage: returning local data');
        return _courses;
      }
    }

    try {
      _courses = await _getRemoteCoursesData();
    } catch (e) {
      rethrow;
    }

    print('> HiveStorage: returning remote data');
    return _courses;
  }

  List<CourseModel> _getLocalCoursesData() {
    final coursesBox = Hive.box(COURSES_BOX);

    final coursesMap = coursesBox.get('courses');

    if (coursesMap == null) {
      return null;
    } else {
      return coursesMap.map((e) => CourseModel.fromMap(e)).toList();
    }
  }

  Future<List<CourseModel>> _getRemoteCoursesData() async {
    try {
      if (!await CheckConnection.checkConnection()) {
        throw PlatformException(
          message: 'Sem conexão com a internet',
          code: 'error_connection',
        );
      }
    } catch (e) {
      rethrow;
    }

    final repository = Modular.get<IDataRepository>();

    try {
      _courses = await repository.getCourses();
      _saveCourses(_courses);
    } catch (e) {
      rethrow;
    }

    return _courses;
  }

  Future<void> _saveCourses(List<CourseModel> courses) async {
    final box = Hive.box(COURSES_BOX);

    await box.clear();

    final data = courses.map((e) => e.toMap()).toList();

    await box.put('courses', data);
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await Hive.box(TASKS_BOX).put(task.id, task.toMap());
  }

  @override
  Future<void> deleteTask(TaskModel task) async {
    await Hive.box(TASKS_BOX).delete(task.id);
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    final tasksBox = await Hive.openBox(TASKS_BOX);
    final tasksMap = <Map>[];
    tasksBox.toMap().forEach((key, value) => tasksMap.add(value));
    return _buildTasks(tasksMap);
  }

  List<TaskModel> _buildTasks(List<dynamic> data) {
    return data.map((e) => TaskModel.fromMap(e)).toList();
  }

  Stream<bool> get onThemeChanged =>
      Hive.box(PREFERENCES_BOX).watch(key: 'darkMode').map((e) {
        print('> change');
        return e.value ?? false;
      });

  ValueListenable<Box> onTasksChanged() => Hive.box(TASKS_BOX).listenable();

  @override
  bool get isDarkMode =>
      Hive.box(PREFERENCES_BOX).get('darkMode', defaultValue: false);

  @override
  Future<void> setDarkMode(bool isDark) async {
    print('> HiveStorage: set dark $isDark');

    await Hive.box(PREFERENCES_BOX).put('darkMode', isDark);
  }

  @override
  Future<void> clearDatabase() async {
    print('> HiveStorage: clear data');

    await Hive.box(PREFERENCES_BOX).clear();
    await Hive.box(COURSES_BOX).clear();
    await Hive.box(TASKS_BOX).clear();
    await Hive.box(PROFILE_BOX).clear();

    print('> HiveStorage: data deleted');
  }

  @override
  void dispose() {}
}
