import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../../infra/drivers/shared_prefs.dart';

class SharedPrefs implements IPrefsStorage {
  final SharedPreferences storage;

  SharedPrefs(this.storage);

  @override
  FutureOr<DateTime> getLastCoursesUpdate() {
    final time = storage.getInt('coursesUpdate') ?? 0;

    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  @override
  FutureOr<DateTime> getLastProfileUpdate() {
    final time = storage.getInt('profileUpdate') ?? 0;

    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  @override
  FutureOr<DateTime> getLastHistoryUpdate() {
    final time = storage.getInt('historyUpdate') ?? 0;

    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  @override
  Future<void> setLastCoursesUpdate(DateTime time) async {
    await storage.setInt('coursesUpdate', time.millisecondsSinceEpoch);
  }

  @override
  Future<void> setLastProfileUpdate(DateTime time) async {
    await storage.setInt('profileUpdate', time.millisecondsSinceEpoch);
  }

  @override
  Future<void> setLastHistoryUpdate(DateTime time) async {
    await storage.setInt('historyUpdate', time.millisecondsSinceEpoch);
  }
}
