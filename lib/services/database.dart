import 'dart:async';

import 'package:aluno_uepb/models/models.dart';
import 'package:aluno_uepb/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'analytics.dart';
import 'connection_state.dart';
import 'scraper/scraper.dart';

class BoxesName {
  static const THEME_BOX = 'themePreference';
  static const LOGIN_BOX = 'login';
  static const COURSES_BOX = 'courses';
  static const TASKS_BOX = 'tasks';
  static const PROFILE_BOX = 'profile';
}

abstract class Database {
  Future<Map<String, dynamic>> getAllData({bool ignoreLocalData});

  Future<List<Task>> getTasksData();

  Future<void> addTask(Task task);

  Future<List<Course>> getCoursesData({bool ignoreLocalData});

  Future<Profile> getProfileData({bool ignoreLocalData});

  Future<void> clearData();

  Future<void> clearBox(String boxName);

  bool get isDarkMode;

  Future<void> setDarkMode(bool isDark);

  Future<void> syncData();

  Future<void> closeDataBase();

  Color getColorTheme();

  Future<void> setColorTheme(Color color);

  Future<void> deleteTask(Task task);

  ValueListenable<Box> onTasksChanged();
}

String documentIdFromCurrentDate() =>
    (DateTime.now().millisecondsSinceEpoch / 6000).floor().toString();

class HiveDatabase implements Database {
  Profile _profile;
  List<Course> _courses;

  static Future<void> initDatabase() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();

    Hive.init(appDocumentDirectory.path);

    await Hive.openBox(BoxesName.THEME_BOX);
    await Hive.openBox(BoxesName.LOGIN_BOX);
    await Hive.openBox(BoxesName.COURSES_BOX);
    await Hive.openBox(BoxesName.TASKS_BOX);
    await Hive.openBox(BoxesName.PROFILE_BOX);
  }

  Future<Map<String, dynamic>> getAllData({bool ignoreLocalData: false}) async {
    if (!ignoreLocalData) {
      // return data from cache
      if (_courses != null) return {'courses': _courses, 'profile': _profile};

      // return data from local database
      _courses = await _getLocalCoursesData();
      _profile = await _getLocalProfileData();

      if (_courses != null && _profile != null)
        return {'courses': _courses, 'profile': _profile};
    }

    // get remote data

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

//     open boxes to store data
    final boxCourses = await Hive.openBox(BoxesName.COURSES_BOX);
    final boxProfile = await Hive.openBox(BoxesName.PROFILE_BOX);

    await boxCourses.clear();
    await boxProfile.clear();

    final user = _getCurrentUser();
    final scraper = Scraper(user: user.user, password: user.password);

    Map<String, dynamic> data;

    try {
      data = await scraper.getAllData();
    } catch (e) {
      rethrow;
    }

    _courses = _buildCourses(data['courses']);
    _profile = _buildProfile(data['profile']);

    final service = Analytics.instance;
    await service.setUserProperties(_profile.toMapFirestore());

    await boxCourses.put('courses', data['courses']);
    await boxProfile.put('profile', data['profile']);

    return {
      'courses': _courses,
      'profile': _profile,
    };
  }

//  Get Courses data

  @override
  Future<List<Course>> getCoursesData({bool ignoreLocalData: false}) async {
    if (!ignoreLocalData) {
      if (_courses != null) return _courses;

      print('> HiveDatabase > getCoursesData : check data in database');
      _courses = await _getLocalCoursesData();

      if (_courses != null) {
        print('> HiveDatabase > getCoursesData : found data in database');
        return _courses;
      }
    }

    try {
      print('> HiveDatabase > getCoursesData : get remote data');
      _courses = await _getRemoteCoursesData();
    } catch (e) {
      rethrow;
    }

    print('> HiveDatabase > getCoursesData : return remote data');
    return _courses;
  }

  Future<List<Course>> _getLocalCoursesData() async {
    final coursesBox = await Hive.openBox(BoxesName.COURSES_BOX);

    final coursesMap = coursesBox.get('courses');

    return coursesMap != null ? _buildCourses(coursesMap) : null;
  }

  Future<List<Course>> _getRemoteCoursesData() async {
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

    final boxCourses = await Hive.openBox(BoxesName.COURSES_BOX);
    await boxCourses.clear();

    final user = _getCurrentUser();
    final scraper = Scraper(user: user.user, password: user.password);

    List<Map<String, dynamic>> data;

    try {
      data = await scraper.getCourses();
    } catch (e) {
      rethrow;
    }

    _courses = _buildCourses(data);
    await boxCourses.put('courses', data);

    return _courses;
  }

  List<Course> _buildCourses(List<dynamic> data) {
    return data.map((e) => Course.fromMap(e)).toList();
  }

//  Get Profile data

  @override
  Future<Profile> getProfileData({bool ignoreLocalData: false}) async {
    if (!ignoreLocalData) {
      if (_profile != null) return _profile;

      print('> HiveDatabase > getProfileData : check data in database');
      _profile = await _getLocalProfileData();

      if (_profile != null) {
        print('> HiveDatabase > getProfileData : found data in database');
        return _profile;
      }
    }

    try {
      print('> HiveDatabase > getProfileData : get remote data');
      _profile = await _getRemoteProfileData();
    } catch (e) {
      rethrow;
    }

    print('> HiveDatabase > getProfileData : return remote data');
    return _profile;
  }

  Future<Profile> _getLocalProfileData() async {
    final profileBox = await Hive.openBox(BoxesName.PROFILE_BOX);
    final profileMap = profileBox.get('profile');

    return profileMap != null ? _buildProfile(profileMap) : null;
  }

  Future<Profile> _getRemoteProfileData() async {
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

    final boxProfile = await Hive.openBox(BoxesName.PROFILE_BOX);
    await boxProfile.clear();

    final user = _getCurrentUser();
    final scraper = Scraper(user: user.user, password: user.password);

    Map<String, dynamic> data;

    try {
      data = await scraper.getProfile();
    } catch (e) {
      rethrow;
    }

    _profile = _buildProfile(data);

    await boxProfile.put('profile', data);

    return _profile;
  }

  Profile _buildProfile(Map<dynamic, dynamic> map) => Profile.fromMap(map);

  static Future<void> clearBoxes() async {
    final coursesBox = await Hive.openBox(BoxesName.COURSES_BOX);
    final profileBox = await Hive.openBox(BoxesName.PROFILE_BOX);
    final tasksBox = await Hive.openBox(BoxesName.TASKS_BOX);

    await coursesBox.clear();
    await profileBox.clear();
    await tasksBox.clear();

    await Hive.box(BoxesName.THEME_BOX).clear();
  }

  // Get tasks data
  @override
  Future<void> addTask(Task task) async {
    await Hive.box(BoxesName.TASKS_BOX).put(task.id, task.toMap());
  }

  @override
  Future<void> deleteTask(Task task) async {
    await Hive.box(BoxesName.TASKS_BOX).delete(task.id);
  }

  @override
  Future<List<Task>> getTasksData() async {
    final tasksBox = await Hive.openBox(BoxesName.TASKS_BOX);
    final tasksMap = List<Map>();
    tasksBox.toMap().forEach((key, value) => tasksMap.add(value));
    return _buildTasks(tasksMap);
  }

  List<Task> _buildTasks(List<dynamic> data) {
    return data.map((e) => Task.fromMap(e)).toList();
  }

  @override
  Future<void> clearData() async {
    await clearBoxes();
    _profile = null;
    _courses = null;
  }

  @override
  Future<void> clearBox(String boxName) async {
    await Hive.box(boxName).clear();
  }

  User _getCurrentUser() {
    final data = Hive.box(BoxesName.LOGIN_BOX).get('user');
    return _userFromDatabase(data);
  }

  User _userFromDatabase(Map data) =>
      User(user: data['user'], password: data['password']);

  @override
  bool get isDarkMode =>
      Hive.box(BoxesName.THEME_BOX).get('darkMode', defaultValue: false);

  @override
  Future<void> setDarkMode(bool isDark) async {
    await Hive.box(BoxesName.THEME_BOX).put('darkMode', isDark);
  }

  @override
  Color getColorTheme() {
    int val = Hive.box(BoxesName.THEME_BOX)
        .get('color', defaultValue: Colors.black.value);
    return Color(val);
  }

  @override
  Future<void> setColorTheme(Color color) async {
    await Hive.box(BoxesName.THEME_BOX).put('color', color.value);
  }

  @override
  Future<void> syncData() async {
    await getAllData(ignoreLocalData: true);
  }

  static ValueListenable<Box> get onDarkModeStateChanged =>
      Hive.box(BoxesName.THEME_BOX).listenable();

  ValueListenable<Box> onTasksChanged() =>
      Hive.box(BoxesName.TASKS_BOX).listenable();

  @override
  Future<void> closeDataBase() async {
    if (Hive.isBoxOpen(BoxesName.COURSES_BOX))
      await Hive.box(BoxesName.COURSES_BOX).close();

    if (Hive.isBoxOpen(BoxesName.PROFILE_BOX))
      await Hive.box(BoxesName.PROFILE_BOX).close();
  }
}
