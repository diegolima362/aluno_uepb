import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/types/types.dart';
import '../../models/models.dart';

abstract class HistoryLocalDataSource {
  AsyncResult<List<History>, AppException> fetchHistory();
  AsyncResult<List<History>, AppException> save(List<History> data);
  AsyncResult<Unit, AppException> clear();
}
