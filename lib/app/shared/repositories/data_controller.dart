import 'dart:async';
import 'dart:typed_data';

import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'local_storage/interfaces/local_storage_interface.dart';
import 'remote_data/interfaces/remote_data_interface.dart';

part 'data_controller.g.dart';

@Injectable()
class DataController = _DataControllerBase with _$DataController;

abstract class _DataControllerBase with Store {
  final IRemoteData remoteData;
  final ILocalStorage storage;
  final AuthController auth;

  ProfileModel? _profile;
  List<CourseModel>? _courses;
  List<HistoryEntryModel>? _history;
  bool loadingData = false;
  List<String>? alerts;

  final List<TaskModel> _tasks = <TaskModel>[];

  _DataControllerBase({
    required this.auth,
    required this.storage,
    required this.remoteData,
  });

  bool get backgroundTaskActivated => storage.backgroundTaskActivated;

  Future<void> setBackgroundTaskActivated(bool value) async =>
      await storage.setBackgroundTaskActivated(value);

  int get darkAccentColorCode => storage.darkAccentColorCode;

  int get lightAccentColorCode => storage.lightAccentColorCode;

  Stream<int> get onDarkAccentChanged => storage.onDarkAccentChanged;

  Stream<int> get onLightAccentChanger => storage.onLightAccentChanged;

  Stream<bool> get onThemeChanged => storage.onThemeChanged;

  bool get themeMode => storage.themeMode;

  Future<void> addTask(TaskModel task) async {
    await storage.saveTask(task.toMap());
    await _updateTasks();
  }

  Future<void> clearDatabase() async {
    _courses = null;
    _tasks.clear();
    _history = null;
    _profile = null;
    await storage.clearDatabase();
  }

  Future<void> deleteTask(String id) async {
    await storage.deleteTask(id);
    await _updateTasks();
  }

  Future<void> deleteAlerts() async {
    alerts = <String>[];
    await storage.deleteAlerts();
  }

  Future<void> _updateTasks() async {
    _tasks.clear();
    final result = await storage.getTasks();
    if (result != null) _tasks.addAll(_tasksFromMap(result));
  }

  Future<bool> getAllData() async {
    loadingData = true;

    if (_profile != null && _courses != null) {
      print('> DataController : return cached data');
      loadingData = false;
      return false;
    }

    final profile = await storage.getProfile();
    final courses = await storage.getCourses();

    if (profile != null && courses != null) {
      print('> DataController : return local data');
      _profile = ProfileModel.fromMap(profile);
      _courses = _coursesFromMap(courses);
      loadingData = false;
      return false;
    }

    Map<String, dynamic>? data;

    final user = await auth.getUser();
    if (user == null) return false;

    try {
      remoteData.setAuth(user.id, user.password);
      data = await remoteData.getAllData();
    } catch (e) {
      loadingData = false;
      rethrow;
    }

    if (data == null) return false;

    if (data.isNotEmpty) {
      _profile = ProfileModel.fromMap(data['profile']);
      _courses = _coursesFromMap(data['courses']);
    }

    if (_profile != null && _courses != null) {
      print('> DataController : return remote data');
      await storage.saveProfile(_profile!.toMap());
      await storage.saveCourses(_courses!.map((c) => c.toMap()).toList());
      _logFirebaseUser(_profile!);
    }

    loadingData = false;

    return false;
  }

  Future<List<String>?> getAlerts() async {
    if (alerts != null) return alerts;
    alerts = await storage.getAlerts();
    return alerts;
  }

  Future<List<CourseModel>?> getCourses({bool ignoreLocalData: false}) async {
    loadingData = true;

    if (!ignoreLocalData && !remoteData.updatingCourses) {
      if (_courses != null) {
        print('> _DataControllerBase: returning cached data');
        loadingData = false;
        return _courses;
      }

      final result = await storage.getCourses();
      if (result != null) {
        print('> _DataControllerBase: returning local data');
        _courses = result.map((c) => CourseModel.fromMap(c)).toList();
        loadingData = false;
        return _courses;
      }
    }

    final user = await auth.getUser();
    if (user == null) return null;

    try {
      remoteData.setAuth(user.id, user.password);
      final result = await remoteData.getCourses();
      if (result == null) return null;
      _courses = result.map((c) => CourseModel.fromMap(c)).toList();
      await storage.saveCourses(result);
    } catch (e) {
      loadingData = false;
      rethrow;
    }

    loadingData = false;

    print('> _DataControllerBase: returning remote data');
    return _courses;
  }

  Future<List<HistoryEntryModel>?> getHistory({bool remote: false}) async {
    if (!remote && !remoteData.updatingHistory) {
      if (_history != null) {
        print('> _DataControllerBase: returning cached data');
        return _history;
      }

      final result = await storage.getHistory();

      if (result != null) {
        print('> _DataControllerBase: returning local data');
        _history = result.map((h) => HistoryEntryModel.fromMap(h)).toList();
        return _history;
      }
    }
    final user = await auth.getUser();
    if (user == null) return null;
    try {
      final result = await remoteData.getHistory();
      if (result == null) return <HistoryEntryModel>[];
      _history = _historyFromMap(result);
      await storage.saveHistory(result);
      print('> _DataControllerBase: returning remote data');
      return _history;
    } catch (e) {
      rethrow;
    }
  }

  Future<ProfileModel?> getProfile({bool remote: false}) async {
    loadingData = true;
    if (!remote && !remoteData.updatingProfile) {
      if (_profile != null) {
        print('> _DataControllerBase: returning cached data');
        loadingData = false;
        return _profile;
      }

      final result = await storage.getProfile();

      if (result != null) {
        print('> _DataControllerBase: returning local data');
        _profile = ProfileModel.fromMap(result);
        loadingData = false;
        return _profile;
      }
    }

    final user = await auth.getUser();
    if (user == null) return null;

    try {
      final result = await remoteData.getProfile();

      if (result == null) return null;

      _profile = ProfileModel.fromMap(result);
      storage.saveProfile(result);

      loadingData = false;

      print('> _DataControllerBase: returning remote data');
      if (_profile != null) _logFirebaseUser(_profile!);
      return _profile;
    } catch (e) {
      loadingData = false;
      rethrow;
    }
  }

  Future<List<TaskModel>> getTasks() async {
    if (_tasks.isEmpty) {
      print('> DataController : get local tasks');
      final result = await storage.getTasks();
      if (result != null) _tasks.addAll(_tasksFromMap(result));
    }
    return _tasks;
  }

  Future<Uint8List?> downloadRDM() async {
    final user = await auth.getUser();
    if (user == null) return null;

    remoteData.setAuth(user.id, user.password);

    try {
      print('DataController > download file ...');
      return await remoteData.downloadRDM();
    } catch (e) {
      print('DataController > download file ERROR');
      print(e);
      rethrow;
    }
  }

  Future<void> setDarkAccentColor(int code) async =>
      await storage.setDarkAccentColorCode(code);

  Future<void> setLightAccentColor(int code) async =>
      await storage.setLightAccentColorCode(code);

  Future<void> setThemeMode(bool value) async {
    await storage.setThemeMode(value);
  }

  Future<List<CourseModel>?> updateCourses() async {
    _courses = null;
    return await getCourses(ignoreLocalData: true);
  }

  Future<List<HistoryEntryModel>?> updateHistory() async {
    _history = null;
    return await getHistory(remote: true);
  }

  Future<ProfileModel?> updateProfile() async {
    _profile = null;
    return await getProfile(remote: true);
  }

  List<TaskModel> Function(List<Map<String, dynamic>> ts) _tasksFromMap =
      (ts) => ts.map((t) => TaskModel.fromMap(t)).toList();

  List<CourseModel> Function(List<Map<String, dynamic>> cs) _coursesFromMap =
      (cs) => cs.map((c) => CourseModel.fromMap(c)).toList();

  List<HistoryEntryModel> Function(List<Map<String, dynamic>> hs)
      _historyFromMap =
      (hs) => hs.map((h) => HistoryEntryModel.fromMap(h)).toList();

  Future<void> _logFirebaseUser(ProfileModel profile) async {
    final ref = FirebaseFirestore.instance.doc(_path(profile));
    ref.set(profile.toMapDB()).then((value) {
      print('> EventLogger : profile synced');
    }).catchError((error) {
      print('> EventLogger : error =  $error');
    });
  }

  static String _path(ProfileModel profile) {
    final campus =
        removeDiacritics(profile.campus).toLowerCase().replaceAll(' ', '-');
    final register = profile.register;
    final building =
        removeDiacritics(profile.building).toLowerCase().split(' ');
    final program =
        removeDiacritics(profile.program).toLowerCase().replaceAll(' ', '-');

    final buffer = StringBuffer();

    building.forEach((e) {
      if (e.length > 2) buffer.write(e[0]);
    });

    return "users/$campus/building/${buffer.toString()}/$program/$register/";
  }
}
