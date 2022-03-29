import '../repositories/alerts_repository.dart';
import '../types/types.dart';

abstract class IRemoveRecurringAlerts {
  Future<EitherUnit> call({int? id, String? course});
}

class RemoveAlerts implements IRemoveRecurringAlerts {
  final IAlertsRepository repository;

  RemoveAlerts(this.repository);

  @override
  Future<EitherUnit> call({int? id, String? course}) async {
    return await repository.deleteRecurringAlerts(id: id, course: course);
  }
}
