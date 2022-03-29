import '../types/types.dart';

abstract class ICoursesRepository {
  Future<EitherCourses> getCourses({String? id, bool cached = true});

  Future<EitherCourses> getTodaysClasses();

  Future<EitherString> getRDM({bool cached = true});
}
