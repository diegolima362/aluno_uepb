import 'package:flutter/material.dart';

import '../../domain/entities/preferences_entity.dart';

class PreferencesModel extends PreferencesEntity {
  final int themeIndex;

  PreferencesModel({
    required this.themeIndex,
    required bool allowNotifications,
    required bool allowAutoDownload,
  }) : super(
          themeMode: ThemeMode.values[themeIndex],
          allowAutoDownload: allowAutoDownload,
          allowNotifications: allowNotifications,
        );

  PreferencesModel copyWith({
    int? themeIndex,
    bool? allowNotifications,
    bool? allowAutoDownload,
  }) {
    return PreferencesModel(
      themeIndex: themeIndex ?? this.themeIndex,
      allowAutoDownload: allowAutoDownload ?? this.allowAutoDownload,
      allowNotifications: allowNotifications ?? this.allowNotifications,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PreferencesModel && other.themeIndex == themeIndex;
  }

  @override
  int get hashCode => themeIndex.hashCode;
}
