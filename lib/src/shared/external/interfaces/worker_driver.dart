import 'package:result_dart/result_dart.dart';

import '../../domain/models/app_exception.dart';

abstract class WorkerDriver {
  AsyncResult<Unit, AppException> schedule();

  AsyncResult<Unit, AppException> cancel(String id);

  AsyncResult<Unit, AppException> cancelAll();
}
