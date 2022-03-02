import 'package:flutter/material.dart';

class PreferencesEntity {
  final ThemeMode themeMode;
  final bool allowAutoDownload;
  final bool allowNotifications;

  PreferencesEntity({
    this.themeMode = ThemeMode.system,
    this.allowAutoDownload = false,
    this.allowNotifications = false,
  });
}
