import '../types/types.dart';

abstract class IWorkerManagerService {
  Future<EitherWorkUnit> scheduleWorker();

  Future<EitherWorkUnit> cancelWorkers({String? id});
}
