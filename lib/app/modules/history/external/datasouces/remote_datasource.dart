import 'package:aluno_uepb/app/modules/auth/domain/usecases/usecases.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';

import '../../../../core/external/utils/urls.dart';
import '../../domain/errors/errors.dart';
import '../../infra/datasources/history_datasource.dart';
import '../../infra/models/models.dart';
import 'utils/parser.dart' as parser;

class HistoryRemoteDatasource implements IHistoryRemoteDatasource {
  final ISignedSession getSession;

  HistoryRemoteDatasource(this.getSession);

  @override
  Future<List<HistoryModel>> getHistory() async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await getSession();

      return await result.fold(
        (l) => throw l,
        (client) async {
          final doc = await client.get(historyURL);

          if (doc != null) {
            return parser.extractHistory(doc);
          } else {
            throw GetHistoryError(
              message: 'Erro na comunicação com o servidor',
            );
          }
        },
      );
    } on ParseError catch (e) {
      throw GetHistoryError(
        message: e.errorCode,
      );
    } finally {
      debugPrint('> GetHistoryRemote executed in ${stopwatch.elapsed}');
    }
  }
}
