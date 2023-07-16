import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import '../../../shared/data/types/open_protocol.dart';
import '../../../shared/external/datasources/implementations.dart';
import '../models/preferences.dart';

// atoms
final themeModeState = Atom<ThemeMode>(ThemeMode.system);
final seedColorState = Atom<Color?>(null);

final backgroundSyncState = Atom<bool>(true);
final notificationsState = Atom<bool>(true);

final implementationState =
    Atom<DataSourceImplementation>(DataSourceImplementation.none);

final protocolSpecState = Atom<OpenProtocolSpec?>(null);

final protocolSpecsState = Atom<List<OpenProtocolSpec>>([]);

final lastSyncState = Atom<DateTime?>(null);

final preferencesLoadingState = Atom<bool>(false);

// actions
final fetchPreferences = Atom.action();
final fetchProtocolSpecs = Atom.action();
final savePreferences = Atom<Preferences?>(null);

final changeImplementation = Atom<DataSourceImplementation?>(null);
final changeProtocolSpec = Atom<OpenProtocolSpec?>(null);

final changeTheme = Atom<ThemeMode?>(null);
final changeSeedColor = Atom<Color?>(null);
final toggleBackgroundSync = Atom<bool?>(null);
final toggleNotifications = Atom<bool?>(null);

final setLastSync = Atom<DateTime?>(null);
