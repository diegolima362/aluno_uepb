import 'dart:async';
import 'dart:typed_data';

import 'package:aluno_uepb/app/core/domain/entities/notification_entity.dart';
import 'package:aluno_uepb/app/core/external/drivers/notifications_driver.dart';
import 'package:aluno_uepb/app/modules/auth/domain/usecases/usecases.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';

import '../../../../core/external/utils/urls.dart';
import '../../domain/errors/errors.dart';
import '../../infra/datasources/courses_datasource.dart';
import '../../infra/models/models.dart';
import 'utils/parser.dart' as parser;

class CoursesRemoteDatasource implements ICoursesRemoteDatasource {
  final ISignedSession getSession;

  CoursesRemoteDatasource(this.getSession);

  @override
  Future<List<CourseModel>> getCourses({String? id}) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await getSession();

      return await result.fold(
        (l) => throw l,
        (r) async {
          final doc = await r.get(rdmURL);

          if (doc != null) {
            return parser.extractCourses(doc);
          } else {
            throw GetCoursesError(
              message: 'Erro ao formatar dados',
            );
          }
        },
      );
    } on ClientException {
      throw GetCoursesError(
        message: 'Erro de conexão!',
      );
    } on TimeoutException {
      throw GetCoursesError(
        message: 'Controle acadêmico indisponível no momento!',
      );
    } finally {
      debugPrint('GetCoursesRemote executed in ${stopwatch.elapsed}');
    }
  }

  @override
  Future<Option<Uint8List>> downloadRDM() async {
    // final stopwatch = Stopwatch()..start();

    final result = await getSession();

    return await result.fold(
      (l) => throw l,
      (r) async {
        final doc = await r.getBytes(rdmPrintURL);

        if (doc != null) {
          return some(doc);
        } else {
          return none();
        }
      },
    );
  }
}

Future<bool> backgroundUpdate() async {
  final a = NotificationsDriver(FlutterLocalNotificationsPlugin());

  a.showAlert(
    NotificationEntity(
      id: 1115,
      title: 'title',
      body: 'body',
      payload: 'payload',
      dateTime: DateTime.now(),
    ),
  );

  return true;
}
