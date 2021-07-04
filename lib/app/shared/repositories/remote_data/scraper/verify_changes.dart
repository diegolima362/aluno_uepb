import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aluno_uepb/app/shared/auth/repositories/interfaces/auth_repository_interface.dart';
import 'package:aluno_uepb/app/shared/auth/repositories/secure_storage/auth_repository.dart';
import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/repositories/local_storage/hive_storage/hive_storage.dart';
import 'package:aluno_uepb/app/shared/repositories/local_storage/interfaces/local_storage_interface.dart';
import 'package:aluno_uepb/app/utils/format.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

import 'scraper.dart';

Future<void> verifyChanges() async {
  Workmanager().executeTask((task, inputData) async {
    final flp = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('app_icon');
    final initSettings = InitializationSettings(android: android);
    flp.initialize(initSettings);
    await runTask(flp);
    return Future.value(true);
  });
}

Future<void> runTask(FlutterLocalNotificationsPlugin flp) async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
    }
  } on SocketException catch (_) {
    print('not connected');
  }

  try {
    IAuthRepository authStorage = FlutterSecureStorageRepository();
    final user = await authStorage.getCurrentUser();

    if (user != null) {
      final u = UserModel.fromMap(user);

      final _scraper = Scraper(
        user: u.id,
        password: u.password,
        debugMode: true,
      );
      final updatedData = (await _scraper.getCourses());

      if (updatedData != null) {
        await _init();
        ILocalStorage storage = HiveStorage();
        final _courses = await _getLocalData(storage);
        if (_courses == null) return;
        await _compareData(flp, updatedData, _courses, storage);
        await storage.saveCourses(updatedData);
      }
    }
    await Hive.box(HiveStorage.COURSES_BOX).close();
  } catch (e) {
    print('Error updating data');
    print(e);
    await Hive.box(HiveStorage.COURSES_BOX).close();
  }
}

void showNotification(
  FlutterLocalNotificationsPlugin flp,
  String message,
) async {
  var android = AndroidNotificationDetails(
    '007',
    'UpdateChannel',
    'Show Notification when data change',
    priority: Priority.max,
    importance: Importance.max,
    icon: 'app_icon',
  );

  var platform = NotificationDetails(android: android);
  await flp.show(
    0,
    'Atualização de RDM',
    'Seu RDM foi atualizado!',
    platform,
    payload: json.encode({'title': message}),
  );
}

Future<FutureOr<void>> _init() async {
  await Hive.initFlutter(HiveStorage.STORAGE_DIR);
  await Hive.openBox(HiveStorage.COURSES_BOX);
}

FutureOr<List<CourseModel>?> _getLocalData(ILocalStorage storage) async {
  final map = await storage.getCourses();
  return map == null ? null : _coursesFromMap(map);
}

Future<void> _compareData(
  FlutterLocalNotificationsPlugin flp,
  List<Map<String, dynamic>> updatedData,
  List<CourseModel> _courses,
  ILocalStorage storage,
) async {
  if (updatedData.length != _courses.length) {
    showNotification(flp, 'Seu RDM foi Atualizado!');
  } else if (updatedData.length == _courses.length) {
    final updateCourses = _coursesFromMap(updatedData);
    final changedIndex = <int>[];

    for (int i = 0; i < updatedData.length; i++) {
      if (_courses[i].toString() != updateCourses[i].toString())
        changedIndex.add(i);
    }

    if (changedIndex.length > 0) {
      final message = <String>[];

      for (int i = 0; i < changedIndex.length; i++) {
        final originalCourse = _courses[changedIndex[i]];
        final updateCourse = updateCourses[changedIndex[i]];
        final professor = Format.capitalString(originalCourse.professor);
        final course = originalCourse.name.toUpperCase();

        if (updateCourse.absences != originalCourse.absences) {
          message.add('$professor registrou uma falta sua em $course!');
        }

        if (originalCourse.und1Grade != updateCourse.und1Grade ||
            originalCourse.und2Grade != updateCourse.und2Grade ||
            originalCourse.finalTest != updateCourse.finalTest) {
          message.add('Sua nota em $course foi registrada!');
        }
      }

      var text = message.fold<String>('', (a, b) => a + b + '\n');

      await Hive.openBox(HiveStorage.ALERTS_BOX);
      await storage.saveAlerts(message);
      Hive.box(HiveStorage.ALERTS_BOX).close();
      showNotification(flp, text);
    }
  }
}

List<CourseModel> Function(List<Map<String, dynamic>> cs) _coursesFromMap =
    (cs) => cs.map((c) => CourseModel.fromMap(c)).toList();
