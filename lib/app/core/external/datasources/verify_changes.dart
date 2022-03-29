import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aluno_uepb/app/core/external/drivers/drivers.dart';
import 'package:aluno_uepb/app/core/infra/services/services.dart';
import 'package:aluno_uepb/app/modules/auth/domain/usecases/signed_session.dart';
import 'package:aluno_uepb/app/modules/auth/external/datasources/auth_datasource.dart';
import 'package:aluno_uepb/app/modules/auth/infra/repositories/auth_repository.dart';
import 'package:aluno_uepb/app/modules/courses/external/datasouces/local_datasource.dart';
import 'package:aluno_uepb/app/modules/courses/external/datasouces/remote_datasource.dart';
import 'package:aluno_uepb/app/modules/courses/infra/models/course_model.dart';
import 'package:aluno_uepb/app/modules/history/external/datasouces/local_datasource.dart';
import 'package:aluno_uepb/app/modules/history/external/datasouces/remote_datasource.dart';
import 'package:aluno_uepb/app/modules/profile/external/datasouces/local_datasource.dart';
import 'package:aluno_uepb/app/modules/profile/external/datasouces/remote_datasource.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

Future<void> verifyChanges() async {
  Workmanager().executeTask((task, inputData) async {
    final flp = FlutterLocalNotificationsPlugin();

    const android = AndroidInitializationSettings('notification_icon');
    const initSettings = InitializationSettings(android: android);

    flp.initialize(initSettings);

    await runTask(flp);

    return true;
  });
}

Future<void> runTask(FlutterLocalNotificationsPlugin flp) async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isEmpty || result[0].rawAddress.isEmpty) {
      return;
    }
  } on SocketException catch (e) {
    debugPrint('> VerifyChanges: not connection => ${e.message}');
    return;
  }

  try {
    final client = Session(Client());
    final db = AppDriftDatabase.connect(createDriftIsolateAndConnect());

    final authDatasource = AuthDatasource(client, db);
    final authRepo = AuthRepository(authDatasource);

    final conect = ConnectivityService(ConnectivityDriver(Connectivity()));

    final getSession = SignedSession(authRepo, conect);

    await updateProfile(db, getSession);
    await updateHistory(db, getSession);
    await updateCourses(db, getSession, flp);

    await markDataAsUpdated();
  } catch (e) {
    debugPrint('> VerifyChanges erro: ${e.toString()}');
  }
}

Future<void> updateProfile(AppDriftDatabase db, ISignedSession session) async {
  final remote = ProfileRemoteDatasource(session);
  final local = ProfileLocalDatasource(db);

  final remoteResult = (await remote.getProfile()).toNullable();

  if (remoteResult != null) await local.saveProfile(remoteResult);
}

Future<void> updateHistory(AppDriftDatabase db, ISignedSession session) async {
  final remote = HistoryRemoteDatasource(session);
  final local = HistoryLocalDatasource(db);

  final remoteResult = (await remote.getHistory());

  if (remoteResult.isNotEmpty) await local.saveHistory(remoteResult);
}

Future<void> updateCourses(
  AppDriftDatabase db,
  ISignedSession session,
  FlutterLocalNotificationsPlugin flp,
) async {
  final remoteCourses = CoursesRemoteDatasource(session);
  final localCourses = CoursesLocalDatasource(db);

  final localResult = await localCourses.getCourses();
  final remoteResult = await remoteCourses.getCourses();

  final message = await compareData(flp, remoteResult, localResult);

  final notify = (await db.prefsDao.allPreferences)?.allowNotifications;

  if (message.isNotEmpty && (notify ?? false)) {
    await showNotification(flp, message);
  }

  await localCourses.saveCourses(remoteResult);
}

Future<String> compareData(
  FlutterLocalNotificationsPlugin flp,
  List<CourseModel> updated,
  List<CourseModel> local,
) async {
  final changedIndex = <int>[];

  updated.sort((a, b) => a.id.toLowerCase().compareTo(b.id.toLowerCase()));
  local.sort((a, b) => a.id.toLowerCase().compareTo(b.id.toLowerCase()));

  for (int i = 0; i < updated.length; i++) {
    if (local[i].id == updated[i].id &&
        local[i].toString() != updated[i].toString()) {
      changedIndex.add(i);
    }
  }

  if (changedIndex.isNotEmpty) {
    final message = <String>[];

    for (int i = 0; i < changedIndex.length; i++) {
      final l = local[changedIndex[i]];
      final u = updated[changedIndex[i]];

      final course = l.name.toUpperCase();

      if (u.absences != l.absences) {
        message.add('${l.professor} registrou uma falta sua em $course!');
      }

      if (l.und1Grade != u.und1Grade ||
          l.und2Grade != u.und2Grade ||
          l.finalTest != u.finalTest) {
        message.add('Sua nota em $course foi registrada!');
      }
    }

    return message.fold<String>('', (a, b) => a + b + '\n');
  }

  return '';
}

Future<void> showNotification(
  FlutterLocalNotificationsPlugin flp,
  String message,
) async {
  var android = AndroidNotificationDetails(
    '007',
    'UpdateChannel',
    channelDescription: 'Notificar mudanças do RDM',
    priority: Priority.max,
    importance: Importance.max,
    icon: 'notification_icon',
    ongoing: true,
    styleInformation: BigTextStyleInformation(
      message,
      contentTitle: 'Atualização de RDM!',
      summaryText: 'Seu RDM foi atualizado!',
    ),
  );

  var platform = NotificationDetails(android: android);
  await flp.show(
    0,
    'Atualização de RDM',
    message,
    platform,
    payload: json.encode({'title': message}),
  );
}

Future<void> markDataAsUpdated() async {
  final sp = await SharedPreferences.getInstance();

  final prefs = SharedPrefs(sp);
  final now = DateTime.now();

  await prefs.setLastCoursesUpdate(now);
  await prefs.setLastProfileUpdate(now);
  await prefs.setLastHistoryUpdate(now);
}
