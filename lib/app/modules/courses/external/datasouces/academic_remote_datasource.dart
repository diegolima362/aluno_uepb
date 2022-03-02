import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/external/drivers/session.dart';
import '../../domain/errors/errors.dart';
import '../../infra/datasources/academic_datasource.dart';
import '../../infra/models/models.dart';
import 'utils/parser.dart' as parser;
import 'utils/urls.dart';

class AcademicRemoteDatasource implements IAcademicRemoteDatasource {
  final Session client;

  AcademicRemoteDatasource(this.client);

  @override
  Future<List<CourseModel>> getCourses() async {
    final options = {'nome_usuario': '172080037', 'senha_usuario': '24061999'};

    final stopwatch = Stopwatch()..start();
    try {
      await client.get(loginURL);
      await client.post(loginURL, options);

      final doc = await client.get(rdmURL);

      if (doc != null) {
        return parser.extractCourses(doc);
      }
    } catch (e) {
      throw ServerError(
        message: 'Erro na comunicação com o servidor: ${e.toString()}',
      );
    } finally {
      debugPrint('doSomething() executed in ${stopwatch.elapsed}');
    }

    return [];
  }

  @override
  Future<Option<ProfileModel>> getProfile() async {
    final options = {'nome_usuario': '172080037', 'senha_usuario': '24061999'};

    final stopwatch = Stopwatch()..start();
    try {
      await client.get(loginURL);
      await client.post(loginURL, options);

      final doc = await client.get(historyURL);

      if (doc != null) {
        return parser.extractProfile(doc);
      }
    } catch (e) {
      throw ServerError(
        message: 'Erro na comunicação com o servidor: ${e.toString()}',
      );
    } finally {
      debugPrint('doSomething() executed in ${stopwatch.elapsed}');
    }

    return none();
  }

  @override
  Future<List<HistoryModel>> getHistory() async {
    final options = {'nome_usuario': '172080037', 'senha_usuario': '24061999'};

    final stopwatch = Stopwatch()..start();
    try {
      await client.get(loginURL);
      await client.post(loginURL, options);

      final doc = await client.get(historyURL);

      if (doc != null) {
        return parser.extractHistory(doc);
      }
    } catch (e) {
      throw ServerError(
        message: 'Erro na comunicação com o servidor: ${e.toString()}',
      );
    } finally {
      debugPrint('doSomething() executed in ${stopwatch.elapsed}');
    }

    return [];
  }
}
