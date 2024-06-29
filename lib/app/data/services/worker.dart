import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';
import 'package:result_dart/result_dart.dart';
import 'package:workmanager/workmanager.dart';

import '../../../main.dart';
import '../../interactor/models/models.dart';
import '../datasources/local/secure_storage/auth_secure_storage_local_datasource.dart';
import '../datasources/local/sqflite/sqflite_database.dart';
import '../datasources/local/sqflite/sqflite_local_datasource.dart';
import '../datasources/remote/suap_uepb/uepb_remote_datasource.dart';
import '../repositories/repositories_implementations.dart';
import 'http_client.dart';

Future<void> initializeWorker() async {
  await Workmanager().initialize(
    workerCallbackDispatcher,
    isInDebugMode: devMode,
  );
}

@pragma('vm:entry-point')
void workerCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await updateData();
    return true;
  });
}

Future<void> updateData() async {
  const secureStorage = FlutterSecureStorage();

  final db = await initializeSqflite();

  final httpClient = HttpClient()
    ..badCertificateCallback = (_, __, ___) => true;

  final client = AppHttpClient(IOClient(httpClient), secureStorage);
  final remoteDataSource = UepbRemoteDatasource(client);
  final authStorage = AuthSecureStorageLocalDataSource(secureStorage);

  final localDataSource = SqfliteLocalDataSource(db);
  final preferencesRepo = PreferencesRepositoryImpl(localDataSource);

  final preferences = (await preferencesRepo.fetchPreferences()).getOrNull();
  if (preferences == null) {
    return;
  }

  final authRepository = AuthRepositoryImpl(remoteDataSource, authStorage);

  final user = (await authRepository.fetchCurrentUser()).getOrNull();

  if (user == null) {
    return;
  }

  remoteDataSource.setToken(user.toJson());

  final courseRepository =
      CoursesRepositoryImpl(localDataSource, remoteDataSource);

  final profileRepository =
      ProfileRepositoryImpl(localDataSource, remoteDataSource);

  final localCourses = (await courseRepository.fetchCourses()).getOrDefault([]);
  final remoteCourses = await courseRepository //
      .fetchCourses()
      .getOrDefault([]);

  if (localCourses.isEmpty || remoteCourses.isEmpty) {
    return;
  }

  final localProfile = (await profileRepository.fetchProfile()).getOrNull();
  final remoteProfile = (await profileRepository.refreshProfile()).getOrNull();

  // Update last sync
  preferencesRepo
      .savePreferences(preferences.copyWith(lastSync: DateTime.now()));

  final notify = preferences.showNotifications;
  if (notify) {
    String payload = '';

    payload += compareCourses(localCourses, remoteCourses);

    if (localProfile != null && remoteProfile != null) {
      payload += compareProfile(localProfile, remoteProfile);
    }

    if (payload.isNotEmpty) {
      await showNotification(payload);
    }
  }
}

String compareCourses(
  List<Course> localCourses,
  List<Course> remoteCourses,
) {
  String payload = '';

  final local = Map.fromEntries(
    localCourses.map(
      (e) => MapEntry(e.code, e),
    ),
  );

  final remote = Map.fromEntries(
    remoteCourses.map(
      (e) => MapEntry(e.code, e),
    ),
  );

  for (final entry in local.entries) {
    final id = entry.key;
    final localCourse = entry.value;
    final remoteCourse = remote[id];

    if (remoteCourse == null) {
      continue;
    }

    if (localCourse.absences != remoteCourse.absences) {
      payload += 'Falta registrada no curso ${localCourse.name}.\n';
    }

    if (remoteCourse.grades.isNotEmpty &&
        localCourse.grades != remoteCourse.grades) {
      final grades = compareGrades(localCourse.grades, remoteCourse.grades);

      if (grades.isNotEmpty) {
        payload += 'Nota alterada no curso ${localCourse.name}.\n$grades';
      }
    }

    final remoteProfessors = remoteCourse.professors.toSet();
    final localProfessors = localCourse.professors.toSet();
    if (localProfessors.difference(remoteProfessors).isNotEmpty) {
      payload += 'Professor alterado no curso ${localCourse.name}.\n';
    }
  }

  return payload;
}

String compareGrades(List<Grade> localGrades, List<Grade> remoteGrades) {
  String payload = '';

  final local = Map.fromEntries(
    localGrades.map((e) => MapEntry(e.label, e)),
  );

  final remote = Map.fromEntries(
    remoteGrades.map((e) => MapEntry(e.label, e)),
  );

  for (final entry in local.entries) {
    final id = entry.key;
    final localGrade = entry.value;
    final remoteGrade = remote[id];

    if (remoteGrade == null) {
      continue;
    }

    if (localGrade.value != remoteGrade.value) {
      payload += '$id • ${remoteGrade.value.replaceAll(',', '.')}.\n';
    }
  }

  return payload;
}

String compareProfile(Profile localProfile, Profile remoteProfile) {
  String payload = '';

  if (localProfile.academicIndexes != remoteProfile.academicIndexes) {
    final local = Map.fromEntries(
      localProfile.academicIndexes.map((e) => MapEntry(e.label, e)),
    );

    final remote = Map.fromEntries(
      remoteProfile.academicIndexes.map((e) => MapEntry(e.label, e)),
    );

    for (final entry in local.entries) {
      final label = entry.key;
      final localIndex = entry.value;
      final remoteIndex = remote[label];

      if (remoteIndex == null) {
        continue;
      }

      if (localIndex.value != remoteIndex.value) {
        payload += '$label • ${remoteIndex.value}.\n';
      }
    }
  }

  if (localProfile.credits != remoteProfile.credits) {
    payload += 'Créditos Atualizados • ${remoteProfile.credits}.\n';
  }

  if (localProfile.totalHours != remoteProfile.totalHours) {
    payload += 'Horas Atualizadas • ${remoteProfile.totalHours}.\n';
  }

  return payload;
}

Future<void> showNotification(String payload) async {
  final plugin = FlutterLocalNotificationsPlugin();

  const androidSettings = AndroidInitializationSettings('notification_icon');

  const initializationSettings = InitializationSettings(
    android: androidSettings,
  );

  await plugin.initialize(initializationSettings);

  final androidChannel = AndroidNotificationDetails(
    'academic_notifier',
    'Atualizações acadêmicas',
    channelDescription: 'Atualizações acadêmicas',
    icon: 'notification_icon',
    styleInformation: BigTextStyleInformation(
      payload,
      contentTitle: 'Você tem novidades!',
    ),
  );

  final channel = NotificationDetails(android: androidChannel);

  try {
    await plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Você tem novidades!',
      payload,
      channel,
      payload: payload,
    );
  } on PlatformException catch (e) {
    debugPrint(e.toString());
  }
}
