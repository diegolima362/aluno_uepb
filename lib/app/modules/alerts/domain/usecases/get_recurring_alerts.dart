import '../repositories/alerts_repository.dart';
import '../types/types.dart';

abstract class IGetRecurringAlerts {
  Future<EitherRecurring> call({int? id, String? course});
}

class GetRecurringAlerts implements IGetRecurringAlerts {
  final IAlertsRepository repository;

  GetRecurringAlerts(this.repository);

  @override
  Future<EitherRecurring> call({int? id, String? course}) {
    return repository.getRecurringAlerts(id: id, course: course);
  }
}
