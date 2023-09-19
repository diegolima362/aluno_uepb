import 'package:result_dart/result_dart.dart';

import '../../domain/models/app_exception.dart';
import '../../external/interfaces/worker_driver.dart';

class WorkerService {
  final WorkerDriver driver;

  WorkerService(this.driver);

  AsyncResult<Unit, AppException> schedule() {
    return driver.schedule();
  }

  AsyncResult<Unit, AppException> cancel(String id) {
    return driver.cancel(id);
  }

  AsyncResult<Unit, AppException> cancelAll() {
    return driver.cancelAll();
  }
}
