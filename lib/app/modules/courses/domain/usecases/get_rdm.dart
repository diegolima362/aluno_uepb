import '../repositories/academic_repository.dart';
import '../types/types.dart';

abstract class IGetRDM {
  Future<EitherCourses> call({bool cached = true});
}

class GetRDM implements IGetRDM {
  final IAcademicRepository repository;

  GetRDM(this.repository);

  @override
  Future<EitherCourses> call({bool cached = true}) async {
    return await repository.getCourses(cached: cached);
  }
}
