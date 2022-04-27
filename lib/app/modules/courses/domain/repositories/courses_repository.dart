import '../types/types.dart';

abstract class ICoursesRepository {
  Future<EitherCourses> getCourses({bool cached = true});

  Future<EitherCourses> getTodaysClasses();

  Future<EitherString> getRDM({bool cached = true});

  Future<EitherCourse> getCourseById(String id);
}
