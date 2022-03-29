import '../repositories/courses_repository.dart';
import '../types/types.dart';

abstract class IGetTodaysClasses {
  Future<EitherCourses> call();
}

class GetTodaysClasses implements IGetTodaysClasses {
  final ICoursesRepository repository;

  GetTodaysClasses(this.repository);

  @override
  Future<EitherCourses> call() async {
    return await repository.getTodaysClasses();
  }
}
