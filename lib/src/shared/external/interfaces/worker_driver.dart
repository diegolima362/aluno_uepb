import 'package:result_dart/result_dart.dart';

import '../../data/types/types.dart';

abstract class WorkerDriver {
  AsyncResult<Unit, AppException> schedule();

  AsyncResult<Unit, AppException> cancel(String id);

  AsyncResult<Unit, AppException> cancelAll();
}
