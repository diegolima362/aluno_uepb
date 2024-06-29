import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../models/course.dart';

abstract class CoursesRepository {
  AsyncResult<List<Course>, AppException> refreshCourses();

  AsyncResult<List<Course>, AppException> fetchCourses();
}
