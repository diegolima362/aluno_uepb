import 'package:result_dart/result_dart.dart';
import 'package:workmanager/workmanager.dart';

import '../../core/exceptions/app_exception.dart';
import '../../interactor/services/worker_service.dart';

class WorkManagerService implements WorkerService {
  final Workmanager plugin;

  WorkManagerService(this.plugin);

  @override
  AsyncResult<Unit, AppException> schedule() async {
    await plugin.registerPeriodicTask(
      "updateCourseTask",
      "Atualizar Dados",
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: const Duration(hours: 1),
      initialDelay: const Duration(seconds: 5),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );

    return Success.unit();
  }

  @override
  AsyncResult<Unit, AppException> cancel() async {
    await plugin.cancelAll();
    return Success.unit();
  }
}
