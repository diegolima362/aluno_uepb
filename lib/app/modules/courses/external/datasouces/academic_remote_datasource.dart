import 'package:aluno_uepb/app/modules/auth/domain/usecases/usecases.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/external/drivers/session.dart';
import '../../../../core/external/utils/urls.dart';
import '../../../auth/domain/errors/errors.dart';
import '../../domain/errors/errors.dart';
import '../../infra/datasources/academic_datasource.dart';
import '../../infra/models/models.dart';
import 'utils/parser.dart' as parser;

class AcademicRemoteDatasource implements IAcademicRemoteDatasource {
  final Session client;
  final ISignedSession getSession;

  AcademicRemoteDatasource(this.client, this.getSession);

  @override
  Future<List<CourseModel>> getCourses() async {
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
            throw ServerError(
              message: 'Erro na comunicação com o servidor',
            );
          }
        },
      );
    } catch (e) {
      throw ServerError(
        message: 'Erro na comunicação com o servidor: ${e.toString()}',
      );
    } finally {
      debugPrint('doSomething() executed in ${stopwatch.elapsed}');
    }
  }

  @override
  Future<Option<ProfileModel>> getProfile() async {
    final stopwatch = Stopwatch()..start();

    try {
      final result = await getSession();

      return await result.fold(
        (l) => throw l,
        (r) async {
          final doc = await client.get(historyURL);

          if (doc != null) {
            return parser.extractProfile(doc);
          } else {
            throw ServerError(
              message: 'Erro na comunicação com o servidor',
            );
          }
        },
      );
    } catch (e) {
      debugPrint('AcademicRemoteDasource > ${e.toString()}');
      throw SignInError(message: 'Erro ao fazer login');
    } finally {
      debugPrint('doSomething() executed in ${stopwatch.elapsed}');
    }
  }

  @override
  Future<List<HistoryModel>> getHistory() async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await getSession();

      return await result.fold(
        (l) => throw l,
        (r) async {
          final doc = await client.get(historyURL);

          if (doc != null) {
            return parser.extractHistory(doc);
          } else {
            throw ServerError(
              message: 'Erro na comunicação com o servidor',
            );
          }
        },
      );
    } catch (e) {
      debugPrint('AcademicRemoteDasource > ${e.toString()}');
      throw SignInError(message: 'Erro ao fazer login');
    } finally {
      debugPrint('doSomething() executed in ${stopwatch.elapsed}');
    }
  }
}
