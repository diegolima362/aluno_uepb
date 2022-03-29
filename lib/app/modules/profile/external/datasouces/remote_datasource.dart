import 'dart:async';

import 'package:aluno_uepb/app/modules/auth/domain/usecases/usecases.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/parser.dart';

import '../../../../core/external/utils/urls.dart';
import '../../domain/errors/errors.dart';
import '../../infra/datasources/profile_datasource.dart';
import '../../infra/models/models.dart';
import 'utils/parser.dart' as parser;

class ProfileRemoteDatasource implements IProfileRemoteDatasource {
  final ISignedSession getSession;

  ProfileRemoteDatasource(this.getSession);

  @override
  Future<Option<ProfileModel>> getProfile() async {
    final stopwatch = Stopwatch()..start();

    try {
      final result = await getSession();

      return await result.fold(
        (l) => throw l,
        (client) async {
          final docs = await Future.wait([
            client.get(homeURL),
            client.get(profileURL),
          ]);

          final home = docs[0];
          final profile = docs[1];

          if (home != null && profile != null) {
            return parser.extractProfile(home, profile);
          } else {
            throw GetProfileError(
              message: 'Error ao obter dados do controle acadêmico!',
            );
          }
        },
      );
    } on TimeoutException catch (e) {
      debugPrint('AcademicRemoteDasource > ${e.toString()}');
      throw GetProfileError(
        message: 'Controle acadêmico indisponível no momento!',
      );
    } on ParseError catch (e) {
      throw GetProfileError(
        message: e.errorCode,
      );
    } finally {
      debugPrint('> GetProfileRemote executed in ${stopwatch.elapsed}');
    }
  }
}
