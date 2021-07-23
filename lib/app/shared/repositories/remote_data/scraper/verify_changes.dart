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

final _debugMode = false;

Future<void> verifyChanges() async {
  Workmanager().executeTask((task, inputData) async {
    final flp = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('notification_icon');
    final initSettings = InitializationSettings(android: android);
    flp.initialize(initSettings);
    await runTask(flp);
    return Future.value(true);
  });
}

Future<void> runTask(FlutterLocalNotificationsPlugin flp) async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isEmpty || result[0].rawAddress.isEmpty) {
      return;
    }
  } on SocketException catch (e) {
    print('WorkerUpdateCourses>\n$e');
    return;
  }

  try {
    IAuthRepository authStorage = SharedPreferencesRepository();
    final user = await authStorage.getCurrentUser();

    if (user != null) {
      final u = UserModel.fromMap(user);

      final _scraper = Scraper(
        user: u.id,
        password: u.password,
        debugMode: _debugMode,
      );

      final updatedData = (await _scraper.getCourses());

      if (updatedData != null && updatedData.isNotEmpty) {
        await _init();
        ILocalStorage storage = HiveStorage();
        final _courses = await _getLocalData(storage);
        if (_courses == null || _courses.isEmpty) return;
        await _compareData(flp, updatedData, _courses, storage);
        await storage.saveCourses(updatedData);
      }
    }
  } catch (e) {
    print('WorkerUpdateCourses>\n$e');
  } finally {
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
    icon: 'notification_icon',
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
  List<CourseModel> local,
  ILocalStorage storage,
) async {
  final updated = _coursesFromMap(updatedData);
  final changedIndex = <int>[];

  updated.sort((a, b) => a.id.toLowerCase().compareTo(b.id.toLowerCase()));
  local.sort((a, b) => a.id.toLowerCase().compareTo(b.id.toLowerCase()));

  for (int i = 0; i < updatedData.length; i++) {
    if (local[i].id == updated[i].id &&
        local[i].toString() != updated[i].toString()) changedIndex.add(i);
  }

  if (changedIndex.length > 0) {
    final message = <String>[];

    for (int i = 0; i < changedIndex.length; i++) {
      final l = local[changedIndex[i]];
      final u = updated[changedIndex[i]];
      final professor = Format.capitalString(l.professor);
      final course = l.name.toUpperCase();

      if (u.absences != l.absences) {
        message.add('$professor registrou uma falta sua em $course!');
      }

      if (l.und1Grade != u.und1Grade ||
          l.und2Grade != u.und2Grade ||
          l.finalTest != u.finalTest) {
        message.add('Sua nota em $course foi registrada!');
      }
    }

    var text = message.fold<String>('', (a, b) => a + b + '\n');

    await Hive.openBox(HiveStorage.ALERTS_BOX);
    await storage.saveAlerts(message);
    await Hive.box(HiveStorage.ALERTS_BOX).close();
    showNotification(flp, text);
  }
}

List<CourseModel> Function(List<Map<String, dynamic>> cs) _coursesFromMap =
    (cs) => cs.map((c) => CourseModel.fromMap(c)).toList();
