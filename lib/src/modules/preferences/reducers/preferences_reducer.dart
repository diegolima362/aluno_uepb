import 'package:asp/asp.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../main.dart';
import '../../../shared/services/worker_service.dart';
import '../atoms/preferences_atom.dart';
import '../data/repositories/preference_repository.dart';

class PreferenceReducer extends Reducer {
  final PreferencesRepository _repository;
  final WorkerService _workerService;

  PreferenceReducer(this._repository, this._workerService) {
    on(() => [fetchPreferences], _fetchPreferences);
    on(() => [fetchProtocolSpecs], _fetchProtocolSpecs);
    on(() => [changeTheme], _changeTheme);
    on(() => [changeSeedColor], _changeSeedColor);
    on(() => [changeImplementation], _changeImplementation);
    on(() => [toggleBackgroundSync], _changeBackgroundSync);
    on(() => [toggleNotifications], _changeNotifications);
    on(() => [setLastSync], _setLastSync);
    on(() => [changeProtocolSpec], _changeProtocolSpec);
    on(() => [clearPreferencesData], _clearPreferencesData);
  }

  void _fetchPreferences() async {
    preferencesLoadingState.value = true;
    final result = await _repository.getPreferences();
    result.fold(
      (success) {
        protocolSpecState.value = success.protocolSpec;
        implementationState.value = success.implementation;
        themeModeState.value = success.themeMode;
        seedColorState.value = success.seedColor;
        backgroundSyncState.value = success.backgroundSync;
        notificationsState.value = success.showNotifications;
        lastSyncState.value = success.lastSync;
      },
      (failure) => null,
    );
    preferencesLoadingState.value = false;
  }

  void _fetchProtocolSpecs() async {
    preferencesLoadingState.value = true;
    protocolSpecsState.setValue([]);
    final result = await _repository.fetchProtocols();
    result.fold(
      (success) => protocolSpecsState.value = success,
      (failure) => null,
    );
    preferencesLoadingState.value = false;
  }

  void _changeTheme() {
    final themeMode = changeTheme.value;
    if (themeMode != null) {
      themeModeState.value = themeMode;
      _repository.updateTheme(themeMode);
    }
  }

  void _changeSeedColor() {
    final seedColor = changeSeedColor.value;
    seedColorState.value = seedColor;
    _repository.updateSeedColor(seedColor);
  }

  void _changeImplementation() {
    final implementation = changeImplementation.value;

    if (implementation != null) {
      implementationState.value = implementation;

      replaceImplementation(implementation, protocolSpecState.value);

      _repository.updateImplementation(implementation);
    }
  }

  void _changeBackgroundSync() {
    final backgroundSync = toggleBackgroundSync.value;
    if (backgroundSync != null) {
      backgroundSyncState.value = backgroundSync;
      _repository.updateBackgroundSync(backgroundSync);
      _workerService.schedule();
      if (!backgroundSync) {
        notificationsState.value = false;
        _repository.updateShowNotifications(false);
        _workerService.cancelAll();
      }
    }
  }

  void _changeProtocolSpec() {
    final spec = changeProtocolSpec.value;
    protocolSpecState.value = spec;
    _repository.updateSpecs(spec);
  }

  void _changeNotifications() {
    final notifications = toggleNotifications.value;
    if (notifications != null) {
      notificationsState.value = notifications;
      _repository.updateShowNotifications(notifications);

      if (notifications) {
        _externalRequestNotificationPermission();
      }
    }
  }

  void _setLastSync() {
    final lastSync = setLastSync.value;
    lastSyncState.value = lastSync;
    _repository.updateLastSync(lastSync);
  }

  void _clearPreferencesData() async {
    await _repository.clear();
    _fetchPreferences();
  }

  Future<void> _externalRequestNotificationPermission() async {
    final flp = Modular.get<FlutterLocalNotificationsPlugin>();

    await flp
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }
}
