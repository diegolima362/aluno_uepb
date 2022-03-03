import '../types/types.dart';

abstract class IAcademicRepository {
  Future<EitherCourses> getCourses({bool cached = true});

  Future<EitherCourses> getTodaysClasses();

  Future<EitherProfile> getProfile({bool cached = true});

  Future<EitherHistory> getHistory({bool cached = true});
}
