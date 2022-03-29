import '../repositories/alerts_repository.dart';
import '../types/types.dart';

abstract class IRemoveTaskReminders {
  Future<EitherUnit> call({
    int? id,
    bool? completed,
    String? course,
  });
}

class RemoveReminders implements IRemoveTaskReminders {
  final IAlertsRepository repository;

  RemoveReminders(this.repository);

  @override
  Future<EitherUnit> call({
    int? id,
    bool? completed,
    String? course,
  }) async {
    return await repository.removeReminders(
      id: id,
      completed: completed,
      course: course,
    );
  }
}
