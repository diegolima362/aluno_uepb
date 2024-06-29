import 'dart:async';

import 'package:result_dart/result_dart.dart';

import '../../injector.dart';
import '../../interactor/atoms/atoms.dart';
import '../repositories/repositories.dart';

final _repository = injector.get<HistoryRepository>();

Future<void> refreshHistory() async {
  setHistoryLoading(true);
  setHistoryResult(null);
  setHistoryState([]);

  setHistoryResult(await _repository.refreshHistory().map(
    (history) {
      setHistoryState(history);
      return 'Histórico atualizado!';
    },
  ));

  setHistoryLoading(false);
}

Future<void> fetchHistory() async {
  setHistoryLoading(true);
  setHistoryResult(null);
  setHistoryState([]);

  setHistoryResult(await _repository.fetchHistory().map(
    (history) {
      setHistoryState(history);
      return 'Histórico atualizado!';
    },
  ));

  setHistoryLoading(false);
}

Future<void> reverseHistory() async {
  setHistoryLoading(true);

  // This is to assure that the loading state is shown
  await Future.delayed(const Duration(milliseconds: 16));

  setHistoryState(historyState.state.reversed.toList());

  setHistoryLoading(false);
}

Future<void> clearHistoryData() async {
  setHistoryLoading(true);
  setHistoryResult(null);
  setHistoryState([]);

  setHistoryLoading(false);
}
