import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../models/preferences.dart';

// atoms.dart
final preferencesState = atom<Preferences?>(null);
final preferencesLoadingState = atom<bool>(false);
final preferencesResultState = atom<Result<String, AppException>?>(null);

// selectors
final themeModeState = selector((get) => get(preferencesState)?.themeMode);
final seedColorState = selector((get) => get(preferencesState)?.seedColor);
final backgroundSyncState =
    selector((get) => get(preferencesState)?.backgroundSync);

final notificationsState =
    selector((get) => get(preferencesState)?.showNotifications);

final lastSyncState = selector((get) => get(preferencesState)?.lastSync);

// setters
final setPreferences = atomAction1<Preferences?>(
  (set, value) => set<Preferences?>(preferencesState, value),
);

final setLastSync = atomAction1<DateTime>(
  (set, value) {
    final preferences = preferencesState.state;
    if (preferences != null) {
      set<Preferences?>(
          preferencesState, preferences.copyWith(lastSync: value));
    }
  },
);

final setPreferenceResult = atomAction1<Result<String, AppException>?>(
  (set, value) => set<Result<String, AppException>?>(
    preferencesResultState,
    value,
  ),
);

final setPreferenceLoading = atomAction1<bool>(
  (set, value) => set<bool>(preferencesLoadingState, value),
);
