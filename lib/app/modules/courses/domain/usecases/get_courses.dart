import '../repositories/courses_repository.dart';
import '../types/types.dart';

abstract class IGetCourses {
  Future<EitherCourses> call({bool cached = true});
}

class GetCourses implements IGetCourses {
  final ICoursesRepository repository;

  GetCourses(this.repository);

  @override
  Future<EitherCourses> call({bool cached = true}) async {
    return await repository.getCourses(cached: cached);
  }
}
