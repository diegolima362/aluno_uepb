import '../repositories/alerts_repository.dart';
import '../types/types.dart';

abstract class IGetTaskReminders {
  Future<EitherReminders> call({int? id, String? course, bool? completed});
}

class GetReminders implements IGetTaskReminders {
  final IAlertsRepository repository;

  GetReminders(this.repository);

  @override
  Future<EitherReminders> call({
    int? id,
    String? course,
    bool? completed,
  }) async {
    return await repository.getTaskReminders(
      id: id,
      course: course,
      completed: completed,
    );
  }
}
