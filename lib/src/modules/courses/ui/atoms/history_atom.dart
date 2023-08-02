import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/types/types.dart';
import '../../models/history.dart';

// atoms
final historyState = Atom<List<History>>([]);
final historyLoadingState = Atom<bool>(true);
final historyResultState = Atom<Result<String, AppException>?>(null);

// actions
final fetchHistory = Atom.action();
final refreshHistory = Atom.action();

final reverseHistory = Atom.action();

final clearHistoryData = Atom.action();
