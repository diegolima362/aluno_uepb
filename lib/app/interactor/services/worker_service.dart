import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';

abstract class WorkerService {
  AsyncResult<Unit, AppException> schedule();

  AsyncResult<Unit, AppException> cancel();
}
