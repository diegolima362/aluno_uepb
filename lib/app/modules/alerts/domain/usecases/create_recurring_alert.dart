import '../entities/entities.dart';
import '../repositories/alerts_repository.dart';
import '../types/types.dart';

abstract class ICreateRecurringAlert {
  Future<EitherUnit> call(RecurringAlertEntity alert);
}

class CreateRecurringAlert implements ICreateRecurringAlert {
  final IAlertsRepository repository;

  CreateRecurringAlert(this.repository);

  @override
  Future<EitherUnit> call(RecurringAlertEntity alert) async {
    return await repository.createRecurringAlert(alert);
  }
}
