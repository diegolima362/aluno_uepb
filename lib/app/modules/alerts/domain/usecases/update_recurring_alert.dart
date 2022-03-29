import '../entities/entities.dart';
import '../repositories/alerts_repository.dart';
import '../types/types.dart';

abstract class IUpdateRecurringAlert {
  Future<EitherUnit> call(RecurringAlertEntity alert);
}

class UpdateRecurringAlert implements IUpdateRecurringAlert {
  final IAlertsRepository repository;

  UpdateRecurringAlert(this.repository);

  @override
  Future<EitherUnit> call(RecurringAlertEntity alert) async {
    return await repository.updateRecurringAlert(alert);
  }
}
