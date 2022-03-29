import 'package:flutter/material.dart';

import '../../domain/entities/preferences_entity.dart';

class PreferencesModel extends PreferencesEntity {
  final int themeIndex;

  PreferencesModel({
    required this.themeIndex,
    required bool allowNotifications,
    required bool allowAutoDownload,
    required int seedColor,
  }) : super(
          themeMode: ThemeMode.values[themeIndex],
          allowAutoDownload: allowAutoDownload,
          allowNotifications: allowNotifications,
          seedColor: seedColor,
        );

  PreferencesModel copyWith({
    int? themeIndex,
    bool? allowNotifications,
    bool? allowAutoDownload,
    int? seedColor,
  }) {
    return PreferencesModel(
      themeIndex: themeIndex ?? this.themeIndex,
      seedColor: seedColor ?? this.seedColor,
      allowAutoDownload: allowAutoDownload ?? this.allowAutoDownload,
      allowNotifications: allowNotifications ?? this.allowNotifications,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PreferencesModel &&
        other.themeMode == themeMode &&
        other.allowAutoDownload == allowAutoDownload &&
        other.allowNotifications == allowNotifications &&
        other.seedColor == seedColor;
  }

  @override
  int get hashCode {
    return themeMode.hashCode ^
        allowAutoDownload.hashCode ^
        allowNotifications.hashCode ^
        seedColor.hashCode;
  }
}
