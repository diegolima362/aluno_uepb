import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../models/history.dart';

abstract class HistoryRepository {
  AsyncResult<List<HistoryEntry>, AppException> fetchHistory();

  AsyncResult<List<HistoryEntry>, AppException> refreshHistory();
}
