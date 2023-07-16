import 'package:flutter/material.dart';

import '../../../shared/data/types/open_protocol.dart';
import '../../../shared/external/datasources/implementations.dart';

class Preferences {
  final ThemeMode themeMode;
  final Color? seedColor;
  final DataSourceImplementation implementation;
  final bool backgroundSync;
  final bool showNotifications;
  final DateTime? lastSync;
  final OpenProtocolSpec? protocolSpec;

  Preferences({
    required this.themeMode,
    this.seedColor,
    required this.implementation,
    required this.backgroundSync,
    required this.showNotifications,
    this.protocolSpec,
    this.lastSync,
  });

  factory Preferences.defaultPreferences() => Preferences(
        themeMode: ThemeMode.system,
        seedColor: null,
        implementation: DataSourceImplementation.none,
        backgroundSync: false,
        showNotifications: false,
        protocolSpec: null,
        lastSync: null,
      );

  Preferences copyWith({
    ThemeMode? themeMode,
    Color? seedColor,
    DataSourceImplementation? implementation,
    OpenProtocolSpec? protocolSpec,
    bool? backgroundSync,
    bool? showNotifications,
    DateTime? lastSync,
  }) {
    return Preferences(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
      implementation: implementation ?? this.implementation,
      backgroundSync: backgroundSync ?? this.backgroundSync,
      showNotifications: showNotifications ?? this.showNotifications,
      protocolSpec: protocolSpec ?? this.protocolSpec,
      lastSync: lastSync ?? this.lastSync,
    );
  }

  Preferences copyWithNullable({
    OpenProtocolSpec? protocolSpec,
    DateTime? lastSync,
    Color? seedColor,
  }) {
    return Preferences(
      themeMode: themeMode,
      seedColor: seedColor,
      implementation: implementation,
      backgroundSync: backgroundSync,
      showNotifications: showNotifications,
      protocolSpec: protocolSpec,
      lastSync: lastSync,
    );
  }
}
