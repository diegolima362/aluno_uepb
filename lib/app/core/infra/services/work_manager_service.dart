import 'package:fpdart/fpdart.dart';

import '../../domain/errors/erros.dart';
import '../../domain/services/work_manager_service.dart';
import '../../domain/types/types.dart';
import '../drivers/work_manager_driver.dart';

class WorkManagerService implements IWorkerManagerService {
  final IWorkManagerDriver driver;

  WorkManagerService(this.driver);

  @override
  Future<EitherWorkUnit> cancelWorkers({String? id}) async {
    try {
      return right(await driver.cancelWorker(id: id));
    } catch (e) {
      return left(
        CancelWorkerError(message: "Erro ao cancelar worker"),
      );
    }
  }

  @override
  Future<EitherWorkUnit> scheduleWorker() async {
    try {
      return right(await driver.scheduleWorker());
    } catch (e) {
      return left(
        ScheduleWorkerError(message: "Erro ao agendar worker"),
      );
    }
  }
}
