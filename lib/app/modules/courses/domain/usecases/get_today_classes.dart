import '../repositories/academic_repository.dart';
import '../types/types.dart';

abstract class IGetTodaysClasses {
  Future<EitherCourses> call();
}

class GetTodaysClasses implements IGetTodaysClasses {
  final IAcademicRepository repository;

  GetTodaysClasses(this.repository);

  @override
  Future<EitherCourses> call() async {
    return await repository.getTodaysClasses();
  }
}
