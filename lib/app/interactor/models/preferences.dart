import 'package:flutter/material.dart';

enum ThemePref {
  brand,
  system,
  custom,
}

class Preferences {
  final ThemeMode themeMode;
  final ThemePref themePref;
  final Color? seedColor;
  final bool backgroundSync;
  final bool showNotifications;
  final DateTime? lastSync;

  Preferences({
    required this.themeMode,
    required this.themePref,
    this.seedColor,
    required this.backgroundSync,
    required this.showNotifications,
    this.lastSync,
  });

  factory Preferences.defaultPreferences() => Preferences(
        themeMode: ThemeMode.system,
        themePref: ThemePref.brand,
        seedColor: null,
        backgroundSync: false,
        showNotifications: false,
        lastSync: null,
      );

  Preferences copyWith({
    ThemeMode? themeMode,
    ThemePref? themePref,
    Color? seedColor,
    bool? backgroundSync,
    bool? showNotifications,
    DateTime? lastSync,
  }) {
    return Preferences(
      themeMode: themeMode ?? this.themeMode,
      themePref: themePref ?? this.themePref,
      seedColor: seedColor ?? this.seedColor,
      backgroundSync: backgroundSync ?? this.backgroundSync,
      showNotifications: showNotifications ?? this.showNotifications,
      lastSync: lastSync ?? this.lastSync,
    );
  }

  Preferences copyWithNullable({
    DateTime? lastSync,
    Color? seedColor,
  }) {
    return Preferences(
      themeMode: themeMode,
      themePref: themePref,
      seedColor: seedColor,
      backgroundSync: backgroundSync,
      showNotifications: showNotifications,
      lastSync: lastSync,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.index,
      'themePref': themePref.index,
      'seedColor': seedColor?.value,
      'backgroundSync': backgroundSync ? 1 : 0,
      'showNotifications': showNotifications ? 1 : 0,
      'lastSync': lastSync?.toIso8601String(),
    };
  }

  factory Preferences.fromMap(Map<String, dynamic> map) {
    return Preferences(
      themeMode: ThemeMode.values[map['themeMode']],
      themePref: ThemePref.values[map['themePref']],
      seedColor: map['seedColor'] != null ? Color(map['seedColor']) : null,
      backgroundSync: map['backgroundSync'] == 1,
      showNotifications: map['showNotifications'] == 1,
      lastSync:
          map['lastSync'] != null ? DateTime.parse(map['lastSync']) : null,
    );
  }

  @override
  String toString() {
    return 'Preferences{themeMode: $themeMode, themePref: $themePref, seedColor: $seedColor, backgroundSync: $backgroundSync, showNotifications: $showNotifications, lastSync: $lastSync}';
  }
}
