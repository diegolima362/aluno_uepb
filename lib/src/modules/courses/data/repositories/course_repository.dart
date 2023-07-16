import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/datasources/remote_datasource.dart';
import '../../../../shared/data/types/types.dart';
import '../../models/models.dart';
import '../datasources/course_datasource.dart';

class CourseRepository {
  final AcademicRemoteDataSource _remote;
  final CourseLocalDataSource _local;

  // final _cache = <String, Course>{};

  CourseRepository(
    this._remote,
    this._local,
  ) {
    // update courses at start
    fetchCourses(true);
  }

  AsyncResult<List<Course>, AppException> fetchCourses([
    bool refresh = false,
  ]) async {
    final local = (await _local.fetchCourses()).getOrDefault([]);

    if (local.isNotEmpty && !refresh) {
      return Success(local);
    }

    final remote = await _remote.fetchCourses();
    return remote.fold(
      (data) async {
        final merged = mergeCourses(local, data);
        await _local.saveAll(merged);

        return Success(merged);
      },
      (failure) => Failure(failure),
    );
  }

  List<Course> mergeCourses(List<Course> local, List<Course> remote) {
    final cache = <String, Course>{};

    for (final course in local) {
      cache[course.courseCode] = course;
    }

    for (final course in remote) {
      final cached = cache[course.courseCode];

      cache[course.courseCode] = course.copyWith(
        id: cached?.id ?? course.courseCode.hashCode,
      );
    }

    return cache.values.toList();
  }

  AsyncResult<Unit, AppException> clear() async {
    _local.clear();

    return Success.unit();
  }
}
