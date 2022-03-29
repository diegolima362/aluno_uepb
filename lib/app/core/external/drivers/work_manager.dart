import 'package:fpdart/fpdart.dart';
import 'package:workmanager/workmanager.dart';

import '../../infra/drivers/work_manager_driver.dart';

class WorkManagerDriver implements IWorkManagerDriver {
  final Workmanager plugin;

  WorkManagerDriver(this.plugin);

  @override
  Future<Unit> cancelWorker({String? id}) async {
    if (id != null) {
      await plugin.cancelByUniqueName(id);
    } else {
      await plugin.cancelAll();
    }

    return unit;
  }

  @override
  Future<Unit> scheduleWorker() async {
    await plugin.registerPeriodicTask(
      "updateCourseTask",
      "Atualizar RDM",
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: const Duration(hours: 1),
      initialDelay: const Duration(seconds: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );

    return unit;
  }
}
