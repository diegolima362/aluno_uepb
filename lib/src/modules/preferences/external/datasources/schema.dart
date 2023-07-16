// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../../../shared/data/types/open_protocol.dart';
import '../../../../shared/external/datasources/implementations.dart';
import '../../models/preferences.dart';

part 'schema.g.dart';

@Collection()
@Name("Preferences")
class IsarPreferencesModel {
  Id id;
  @enumerated
  ThemeMode themeMode;
  int? seedColor;
  @enumerated
  DataSourceImplementation implementation = DataSourceImplementation.none;
  bool backgroundSync;
  bool showNotifications;
  IsarProtocolSpecModel? protocolSpec;
  DateTime? lastSync;

  IsarPreferencesModel({
    this.id = 1,
    this.themeMode = ThemeMode.system,
    this.seedColor,
    this.implementation = DataSourceImplementation.none,
    this.backgroundSync = false,
    this.showNotifications = false,
    this.protocolSpec,
    this.lastSync,
  });

  @ignore
  Preferences get toDomain => Preferences(
        themeMode: themeMode,
        seedColor: seedColor != null ? Color(seedColor!) : null,
        implementation: implementation,
        backgroundSync: backgroundSync,
        showNotifications: showNotifications,
        protocolSpec: protocolSpec?.toDomain(),
        lastSync: lastSync,
      );

  factory IsarPreferencesModel.fromDomain(Preferences preferences) =>
      IsarPreferencesModel(
        themeMode: preferences.themeMode,
        seedColor: preferences.seedColor?.value,
        implementation: preferences.implementation,
        backgroundSync: preferences.backgroundSync,
        showNotifications: preferences.showNotifications,
        lastSync: preferences.lastSync,
        protocolSpec: preferences.protocolSpec != null
            ? IsarProtocolSpecModel.fromDomain(preferences.protocolSpec!)
            : null,
      );
}

@embedded
@Name("Protocol")
class IsarProtocolSpecModel {
  String title;
  String authUrl;
  String coursesUrl;
  String profileUrl;
  String historyUrl;

  IsarProtocolSpecModel({
    this.title = '',
    this.authUrl = '',
    this.coursesUrl = '',
    this.profileUrl = '',
    this.historyUrl = '',
  });

  factory IsarProtocolSpecModel.fromDomain(OpenProtocolSpec spec) =>
      IsarProtocolSpecModel(
        title: spec.title,
        authUrl: spec.authUrl,
        coursesUrl: spec.coursesUrl,
        profileUrl: spec.profileUrl,
        historyUrl: spec.historyUrl,
      );

  OpenProtocolSpec toDomain() => OpenProtocolSpec(
        title: title,
        authUrl: authUrl,
        coursesUrl: coursesUrl,
        profileUrl: profileUrl,
        historyUrl: historyUrl,
      );
}
