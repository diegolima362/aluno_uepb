import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../data/repositories/history_repository.dart';
import '../atoms/history_atom.dart';

class HistoryReducer extends Reducer {
  final HistoryRepository _historyRepository;

  HistoryReducer(this._historyRepository) {
    on(() => [fetchHistory], _fetchHistory);
    on(() => [refreshHistory], () => _fetchHistory(true));
    on(() => [reverseHistory], _reverseHistory);
  }

  void _fetchHistory([bool refresh = false]) async {
    historyLoadingState.value = true;
    historyResultState.value = null;
    historyState.value = [];

    final result = await _historyRepository.fetchHistory(refresh);

    result.fold(
      (success) {
        historyState.setValue(success);
        if (refresh) {
          historyResultState.value = Result.success('Histórico atualizado!');
        }
      },
      (failure) => historyResultState.value = Result.failure(failure),
    );

    historyLoadingState.value = false;
  }

  void _reverseHistory() async {
    historyLoadingState.value = true;
    await Future.delayed(const Duration(milliseconds: 16));
    historyState.setValue(historyState.value.reversed.toList());
    historyLoadingState.value = false;
  }
}
