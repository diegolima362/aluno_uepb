import 'dart:async';

abstract class IPrefsStorage {
  Future<void> setLastCoursesUpdate(DateTime time);

  Future<void> setLastProfileUpdate(DateTime time);

  Future<void> setLastHistoryUpdate(DateTime dateTime);

  FutureOr<DateTime> getLastProfileUpdate();

  FutureOr<DateTime> getLastCoursesUpdate();

  FutureOr<DateTime> getLastHistoryUpdate();
}
