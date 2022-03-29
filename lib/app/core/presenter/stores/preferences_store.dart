import 'package:aluno_uepb/app/core/domain/services/work_manager_service.dart';
import 'package:aluno_uepb/app/modules/alerts/domain/usecases/remove_recurring_alerts.dart';
import 'package:aluno_uepb/app/modules/preferences/domain/entities/preferences_entity.dart';
import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../modules/preferences/domain/erros/erros.dart';
import '../../../modules/preferences/domain/usecases/usecases.dart';
import '../../infra/drivers/connectivity_driver.dart';
import 'auth_store.dart';

typedef PreferencesStoreType
    = NotifierStore<PreferencesFailure, PreferencesState>;

class PreferencesStore extends PreferencesStoreType {
  final IGetPreferences getPreferences;
  final ISetPreferences setPreferences;
  final IWorkerManagerService workerManagerService;
  final IConnectivityDriver connectivity;
  final IRemoveRecurringAlerts removeRecurringAlerts;

  final IAuthStore authStore;

  PreferencesStore(
    this.connectivity,
    this.authStore,
    this.removeRecurringAlerts,
    this.getPreferences,
    this.setPreferences,
    this.workerManagerService,
  ) : super(PreferencesState());

  bool get isOnline {
    if (!state.isOnline) _checkNetwork();

    return state.isOnline;
  }

  void _checkNetwork() async {
    try {
      final result = await connectivity.isOnline;
      update(state.copyWith(isOnline: result));
    } catch (e) {
      update(state.copyWith(isOnline: false));
    }
  }

  void checkStatus() {
    connectivity.connectionStream.listen((e) => _checkNetwork());

    _checkNetwork();
  }

  Future<void> getData() async {
    setLoading(true);
    final result = await getPreferences();

    result.fold(
      (l) {
        AsukaSnackbar.warning(l.message);
        setError(l);
      },
      (r) => update(state.fromEntity(r)),
    );
  }

  Future<void> setTheme(ThemeMode? val) async {
    if (val == null) return;

    update(state.copyWith(themeMode: val));

    final result = await setPreferences(state.asEntity);

    result.fold(
      (l) => AsukaSnackbar.warning(l.message),
      (r) => r,
    );
  }

  ThemeMode get currentTheme => state.themeMode;

  Future<int> getPendingNotifications() async {
    final result =
        await FlutterLocalNotificationsPlugin().pendingNotificationRequests();

    update(state.copyWith(pendingNotifications: result.length));

    return result.length;
  }

  Future<void> cancelPendingNotifications() async {
    await removeRecurringAlerts();
    update(state.copyWith(pendingNotifications: 0));
  }

  Future<void> toggleWorker(bool value) async {
    if (value) {
      workerManagerService.scheduleWorker();

      update(state.copyWith(allowWorker: true, allowNotifications: false));
      setPreferences(state.asEntity);
    } else {
      workerManagerService.cancelWorkers();

      update(state.copyWith(allowWorker: false, allowNotifications: false));
      setPreferences(state.asEntity);
    }
  }

  Future<void> toggleNotifications(bool value) async {
    update(state.copyWith(allowNotifications: value));
    setPreferences(state.asEntity);
  }

  Future<void> setColor(int? value) async {
    if (value == null) return;

    update(state.copyWith(seedColor: value));

    await setPreferences(state.asEntity);
  }
}

class PreferencesState {
  final ThemeMode themeMode;
  final bool isOnline;
  final bool allowWorker;
  final bool allowNotifications;
  final int pendingNotifications;
  final int seedColor;

  PreferencesState({
    this.themeMode = ThemeMode.system,
    this.isOnline = true,
    this.allowNotifications = false,
    this.allowWorker = false,
    this.pendingNotifications = 0,
    this.seedColor = 0xFF6750A4,
  });

  PreferencesEntity get asEntity => PreferencesEntity(
        themeMode: themeMode,
        allowAutoDownload: allowWorker,
        allowNotifications: allowNotifications,
        seedColor: seedColor,
      );

  PreferencesState copyWith({
    ThemeMode? themeMode,
    bool? isOnline,
    bool? allowWorker,
    bool? allowNotifications,
    int? pendingNotifications,
    int? seedColor,
  }) {
    return PreferencesState(
      themeMode: themeMode ?? this.themeMode,
      isOnline: isOnline ?? this.isOnline,
      allowNotifications: allowNotifications ?? this.allowNotifications,
      allowWorker: allowWorker ?? this.allowWorker,
      pendingNotifications: pendingNotifications ?? this.pendingNotifications,
      seedColor: seedColor ?? this.seedColor,
    );
  }

  PreferencesState fromEntity(PreferencesEntity r) => copyWith(
        themeMode: r.themeMode,
        allowNotifications: r.allowNotifications,
        allowWorker: r.allowAutoDownload,
        seedColor: r.seedColor,
      );
}
