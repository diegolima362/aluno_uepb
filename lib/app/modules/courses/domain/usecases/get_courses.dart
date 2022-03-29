import '../repositories/courses_repository.dart';
import '../types/types.dart';

abstract class IGetCourses {
  Future<EitherCourses> call({String? id, bool cached = true});
}

class GetCourses implements IGetCourses {
  final ICoursesRepository repository;

  GetCourses(this.repository);

  @override
  Future<EitherCourses> call({String? id, bool cached = true}) async {
    return await repository.getCourses(id: id, cached: cached);
  }
}
