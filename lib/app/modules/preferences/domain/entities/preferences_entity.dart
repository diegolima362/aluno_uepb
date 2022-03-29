import 'package:flutter/material.dart';

class PreferencesEntity {
  final ThemeMode themeMode;
  final bool allowAutoDownload;
  final bool allowNotifications;
  final int seedColor;

  PreferencesEntity({
    this.themeMode = ThemeMode.system,
    this.allowAutoDownload = false,
    this.allowNotifications = false,
    this.seedColor = 0xff34c759,
  });
}
