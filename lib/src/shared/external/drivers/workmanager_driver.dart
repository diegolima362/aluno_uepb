import 'package:result_dart/result_dart.dart';
import 'package:workmanager/workmanager.dart';

import '../../data/types/types.dart';
import '../interfaces/worker_driver.dart';

class WorkManagerDriver implements WorkerDriver {
  final Workmanager plugin;

  WorkManagerDriver(this.plugin);
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
  AsyncResult<Unit, AppException> cancel(String id) async {
    await plugin.cancelByUniqueName(id);

    return Success.unit();
  }

  @override
  AsyncResult<Unit, AppException> cancelAll() async {
    await plugin.cancelAll();

    return Success.unit();
  }
}
