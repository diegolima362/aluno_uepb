import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:result_dart/result_dart.dart';

import '../../injector.dart';
import '../../interactor/atoms/atoms.dart';
import '../repositories/repositories.dart';
import '../services/services.dart';

final _repository = injector.get<PreferencesRepository>();
final _workerService = injector.get<WorkerService>();

Future<void> fetchPreferences() async {
  setPreferenceLoading(true);
  setPreferenceResult(null);
  await _repository.fetchPreferences().fold(
        (value) => setPreferences(value),
        (failure) => setPreferenceResult(Failure(failure)),
      );
  setPreferenceLoading(false);
}

Future<void> setThemeMode(ThemeMode? value) async {
  final newPreferences = preferencesState.state!.copyWith(
    themeMode: value,
  );
  setPreferences(newPreferences);
  await _repository.savePreferences(newPreferences);
}

Future<void> setSeedColor(Color? value) async {
  final newPreferences = preferencesState.state!.copyWith(
    seedColor: value,
  );
  setPreferences(newPreferences);
  await _repository.savePreferences(newPreferences);
}

Future<void> setBackgroundSync(bool value) async {
  final newPreferences = preferencesState.state!.copyWith(
    backgroundSync: value,
  );
  if (value) {
    await _workerService.schedule();
  } else {
    await _workerService.cancel();
  }
  setPreferences(newPreferences);
  await _repository.savePreferences(newPreferences);
}

Future<void> setShowNotifications(bool value) async {
  if (value) {
    await _externalRequestNotificationPermission();
  }

  final newPreferences = preferencesState.state!.copyWith(
    showNotifications: value,
  );
  setPreferences(newPreferences);
}

Future<void> updateLastSync(DateTime? value) async {
  final newPreferences = preferencesState.state!.copyWith(
    lastSync: value,
  );
  setPreferences(newPreferences);
  await _repository.savePreferences(newPreferences);
}

Future<void> clearPreferencesData() async {
  setPreferenceLoading(true);
  setPreferenceResult(null);
  await _repository.clearPreferences();
  return fetchPreferences();
}

Future<void> _externalRequestNotificationPermission() async {
  final flp = injector.get<FlutterLocalNotificationsPlugin>();

  await flp
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}
