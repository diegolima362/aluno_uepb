import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../models/history.dart';

// atoms.dart
final historyState = atom<List<HistoryEntry>>([]);
final historyLoadingState = atom<bool>(true);
final historyResultState = atom<Result<String, AppException>?>(null);

// setters

final setHistoryState = atomAction1<List<HistoryEntry>>(
  (set, value) => set<List<HistoryEntry>>(historyState, value),
);

final setHistoryLoading = atomAction1<bool>(
  (set, value) => set<bool>(historyLoadingState, value),
);

final setHistoryResult = atomAction1<Result<String, AppException>?>(
  (set, value) => set<Result<String, AppException>?>(historyResultState, value),
);
