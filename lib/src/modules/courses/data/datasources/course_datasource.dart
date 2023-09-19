import 'package:result_dart/result_dart.dart';

import '../../../../shared/domain/models/app_exception.dart';
import '../../models/models.dart';

abstract class CourseLocalDataSource {
  AsyncResult<List<Course>, AppException> fetchCourses();
  AsyncResult<Course, AppException> fetchCourse(int id);
  AsyncResult<Course, AppException> save(Course data);
  AsyncResult<List<Course>, AppException> saveAll(List<Course> data);
  AsyncResult<Unit, AppException> clear();
}
