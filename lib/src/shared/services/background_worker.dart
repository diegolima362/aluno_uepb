import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:result_dart/result_dart.dart';
import 'package:workmanager/workmanager.dart';

import '../../modules/auth/data/repositories/auth_repository.dart';
import '../../modules/auth/external/datasources/auth_secure_storage_local_datasource.dart';
import '../../modules/courses/data/repositories/course_repository.dart';
import '../../modules/courses/external/course_isar_local_datasource.dart';
import '../../modules/courses/external/schema.dart';
import '../../modules/courses/models/models.dart';
import '../../modules/preferences/data/repositories/preference_repository.dart';
import '../../modules/preferences/external/datasources/preferences_isar_local_datasource.dart';
import '../../modules/preferences/external/datasources/preferences_mock_remote_datasource.dart';
import '../../modules/preferences/external/datasources/schema.dart';
import '../../modules/profile/data/repositories/profile_repository.dart';
import '../../modules/profile/external/profile_isar_local_datasource.dart';
import '../../modules/profile/external/schema.dart';
import '../../modules/profile/models/profile.dart';
import '../data/datasources/remote_datasource.dart';
import '../data/types/open_protocol.dart';
import '../data/types/types.dart';
import '../external/datasources/ca_uepb/datasource.dart';
import '../external/datasources/ca_ufcg/datasource.dart';
import '../external/datasources/implementations.dart';
import '../external/datasources/open_protocol/datasource.dart';
import '../external/datasources/suap_uepb/datasource.dart';
import '../external/drivers/http_client.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await updateData();
    return true;
  });
}

AcademicRemoteDataSource _getRemoteDataSourceImplementation(
  DataSourceImplementation impl,
  AppHttpClient client, [
  OpenProtocolSpec? spec,
]) {
  switch (impl) {
    case DataSourceImplementation.suapUepb:
      return SuapUpebRemoteDataSource(client);
    case DataSourceImplementation.caUepb:
      return CaUepbRemoteDataSource(client);
    case DataSourceImplementation.caUfcg:
      return CaUfcgRemoteDataSource(client);
    case DataSourceImplementation.openProtocol:
      return OpenProtocolRemoteDataSource(client, spec!);
    default:
      throw AppException('Invalid implementation');
  }
}

Future<void> updateData() async {
  final dir = await getApplicationDocumentsDirectory();
  const secureStorage = FlutterSecureStorage();

  final isar = await Isar.open(directory: dir.path, [
    IsarPreferencesModelSchema,
    IsarCourseModelSchema,
    IsarHistoryModelSchema,
    IsarProfileModelSchema,
  ]);
  final httpClient = HttpClient()
    ..badCertificateCallback = (_, __, ___) => true;

  final client = AppHttpClient(IOClient(httpClient), secureStorage);

  final preferencesRepo = PreferencesRepository(
    PreferencesIsarLocalDataSource(isar),
    PreferencesMockRemoteDataSource(),
  );

  final preferences = (await preferencesRepo.getPreferences()).getOrNull();
  if (preferences == null) {
    return;
  }

  final AcademicRemoteDataSource remoteDataSource =
      _getRemoteDataSourceImplementation(
    preferences.implementation,
    client,
    preferences.protocolSpec,
  );

  final authRepository = AuthRepository(
    AuthSecureStorageLocalDataSource(secureStorage),
    remoteDataSource,
  );

  final user = (await authRepository.fetchCurrentUser()).getOrNull();

  if (user == null) {
    return;
  }

  remoteDataSource.setUser(user);

  final courseRepository = CourseRepository(
    remoteDataSource,
    CourseIsarLocalDataSource(isar),
  );

  final profileRepository = ProfileRepository(
    remoteDataSource,
    ProfileIsarLocalDataSource(isar),
  );

  final localCourses = (await courseRepository.fetchCourses()).getOrDefault([]);
  final remoteCourses = await courseRepository //
      .fetchCourses(true)
      .getOrDefault([]);

  if (localCourses.isEmpty || remoteCourses.isEmpty) {
    return;
  }

  final localProfile = (await profileRepository.getProfile()).getOrNull();
  final remoteProfile = (await profileRepository.getProfile(true)).getOrNull();

  // Update last sync
  preferencesRepo.updateLastSync(DateTime.now());

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
      (e) => MapEntry(e.id, e),
    ),
  );

  final remote = Map.fromEntries(
    remoteCourses.map(
      (e) => MapEntry(e.id, e),
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
      payload += 'Falta registrada no curso ${localCourse.title}.\n';
    }

    if (remoteCourse.grades.isNotEmpty &&
        localCourse.grades != remoteCourse.grades) {
      final grades = compareGrades(localCourse.grades, remoteCourse.grades);

      if (grades.isNotEmpty) {
        payload += 'Nota alterada no curso ${localCourse.title}.\n$grades';
      }
    }

    final remoteProfessors = remoteCourse.professors.toSet();
    final localProfessors = localCourse.professors.toSet();
    if (localProfessors.difference(remoteProfessors).isNotEmpty) {
      payload += 'Professor alterado no curso ${localCourse.title}.\n';
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
