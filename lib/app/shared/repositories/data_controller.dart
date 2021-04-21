import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/event_logger/event_logger.dart';
import 'package:aluno_uepb/app/shared/event_logger/interfaces/event_logger_interface.dart';
import 'package:aluno_uepb/app/shared/models/course_model.dart';
import 'package:aluno_uepb/app/shared/models/history_entry_model.dart';
import 'package:aluno_uepb/app/shared/models/profile_model.dart';
import 'package:aluno_uepb/app/shared/models/task_model.dart';
import 'package:aluno_uepb/app/shared/repositories/local_storage/interfaces/local_storage_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/scraper/scraper.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'data_controller.g.dart';

@Injectable()
class DataController = _DataControllerBase with _$DataController;

abstract class _DataControllerBase with Store {
  late final Scraper _scraper;
  late final ILocalStorage _storage;

  ProfileModel? _profile;
  List<CourseModel>? _courses;
  List<HistoryEntryModel>? _history;
  bool loadingData = false;

  final List<TaskModel> _tasks = <TaskModel>[];

  _DataControllerBase() {
    final user = Modular.get<AuthController>().user;

    _scraper = Scraper(user?.id ?? '', user?.password ?? '');
    _storage = Modular.get();
  }

  int get darkAccentColorCode => _storage.darkAccentColorCode;

  int get lightAccentColorCode => _storage.lightAccentColorCode;

  Stream<int> get onDarkAccentChanged => _storage.onDarkAccentChanged;

  Stream<int> get onLightAccentChanger => _storage.onLightAccentChanged;

  Stream<bool> get onThemeChanged => _storage.onThemeChanged;

  bool get themeMode => _storage.themeMode;

  Future<void> addTask(TaskModel task) async {
    await _storage.saveTask(task);
    print('> DataController : save task');
    _tasks.clear();
    final result = await _storage.getTasks();
    if (result != null) _tasks.addAll(result);
  }

  Future<void> clearDatabase() async {
    _courses = null;
    _tasks.clear();
    _history = null;
    _profile = null;
    await _storage.clearDatabase();
  }

  Future<void> deleteTask(String id) async {
    await _storage.deleteTask(id);
    _tasks.clear();
    final result = await _storage.getTasks();
    if (result != null) _tasks.addAll(result);
  }

  Future<bool> getAllData() async {
    loadingData = true;

    if (_profile != null && _courses != null) {
      print('> DataController : return cached data');
      loadingData = false;
      return false;
    }

    _profile = await _storage.getProfile();
    _courses = await _storage.getCourses();

    if (_profile != null && _courses != null) {
      print('> DataController : return local data');
      loadingData = false;
      return false;
    }

    Map<String, dynamic> data;

    try {
      data = await _scraper.getAllData();
    } catch (e) {
      print('> DataController : error');
      print(e);
      loadingData = false;
      return false;
    }

    if (data.isNotEmpty) {
      _profile = data['profile'];
      _courses = data['courses'];
    }

    if (_profile != null && _courses != null) {
      print('> DataController : return remote data');
      await _storage.saveProfile(_profile!);
      await _storage.saveCourses(_courses!);
      Modular.get<EventLogger>().setData(_profile!);
    }

    loadingData = false;
    return false;
  }

  Future<List<CourseModel>?> getCourses({bool ignoreLocalData: false}) async {
    loadingData = true;

    if (!ignoreLocalData && !_scraper.updatingCourses) {
      if (_courses != null) {
        print('> _DataControllerBase: returning cached data');
        loadingData = false;
        return _courses;
      }
      _courses = await _storage.getCourses();

      if (_courses != null) {
        print('> _DataControllerBase: returning local data');
        loadingData = false;
        return _courses;
      }
    }

    try {
      final result = await _scraper.getCourses();
      if (result == null) return null;
      _courses = result;
      await _storage.saveCourses(result);
    } catch (e) {
      loadingData = false;
      rethrow;
    }

    loadingData = false;

    print('> _DataControllerBase: returning remote data');
    return _courses;
  }

  Future<List<HistoryEntryModel>?> getHistory({bool remote: false}) async {
    if (!remote && !_scraper.updatingHistory) {
      if (_history != null) {
        print('> _DataControllerBase: returning cached data');
        return _history;
      }
      final result = await _storage.getHistory();
      if (result != null) {
        print('> _DataControllerBase: returning local data');

        _history = result;
        return result;
      }
    }

    try {
      final result = await _scraper.getHistory();
      if (result == null) return <HistoryEntryModel>[];
      _history = result;
      await _storage.saveHistory(result);
      print('> _DataControllerBase: returning remote data');
      return _history;
    } catch (e) {
      rethrow;
    }
  }

  Future<ProfileModel?> getProfile({bool remote: false}) async {
    loadingData = true;
    if (!remote && !_scraper.updatingProfile) {
      if (_profile != null) {
        print('> _DataControllerBase: returning cached data');
        loadingData = false;
        return _profile;
      }
      _profile = await _storage.getProfile();

      if (_profile != null) {
        print('> _DataControllerBase: returning local data');

        loadingData = false;
        return _profile;
      }
    }

    try {
      final result = await _scraper.getProfile();

      if (result == null) return null;

      _profile = result;
      Modular.get<IEventLogger>().setData(result);
      _storage.saveProfile(result);

      loadingData = false;

      print('> _DataControllerBase: returning remote data');
      return result;
    } catch (e) {
      loadingData = false;
      rethrow;
    }
  }

  Future<List<TaskModel>> getTasks() async {
    if (_tasks.isEmpty) {
      print('> DataController : get local tasks');
      final result = await _storage.getTasks();
      if (result != null) _tasks.addAll(result);
    }
    return _tasks;
  }

  Future<void> setDarkAccentColor(int code) async =>
      await _storage.setDarkAccentColorCode(code);

  Future<void> setLightAccentColor(int code) async =>
      await _storage.setLightAccentColorCode(code);

  Future<void> setThemeMode(bool value) async {
    await _storage.setThemeMode(value);
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
}
