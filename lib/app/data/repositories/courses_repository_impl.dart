import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../../interactor/datasources/academic_datasource.dart';
import '../../interactor/models/course.dart';
import '../../interactor/repositories/repositories.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  final AppLocalDataSource _localDataSource;
  final AppRemoteDataSource _remoteDataSource;

  CoursesRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  AsyncResult<List<Course>, AppException> fetchCourses() async {
    try {
      final courses = await _localDataSource.fetchCourses();
      if (courses.isEmpty) {
        return refreshCourses();
      }
      return Success(courses);
    } on AppException catch (e) {
      return Failure(e);
    }
  }

  @override
  AsyncResult<List<Course>, AppException> refreshCourses() async {
    try {
      final courses = await _remoteDataSource.fetchCourses();
      await _localDataSource.cacheCourses(courses);
      return Success(courses);
    } on AppException catch (e) {
      return Failure(e);
    }
  }
}
