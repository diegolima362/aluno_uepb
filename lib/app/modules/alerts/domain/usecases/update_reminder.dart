import '../entities/entities.dart';
import '../repositories/alerts_repository.dart';
import '../types/types.dart';

abstract class IUpdateTaskReminder {
  Future<EitherUnit> call(TaskReminderEntity reminder);
}

class UpdateReminder implements IUpdateTaskReminder {
  final IAlertsRepository repository;

  UpdateReminder(this.repository);

  @override
  Future<EitherUnit> call(TaskReminderEntity reminder) async {
    return await repository.updateReminder(reminder);
  }
}
