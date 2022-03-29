import '../entities/entities.dart';
import '../repositories/alerts_repository.dart';
import '../types/types.dart';

abstract class ICreateRemidner {
  Future<EitherUnit> call(TaskReminderEntity reminder);
}

class CreateReminder implements ICreateRemidner {
  final IAlertsRepository repository;

  CreateReminder(this.repository);

  @override
  Future<EitherUnit> call(TaskReminderEntity reminder) async {
    return await repository.createTaskReminder(reminder);
  }
}
