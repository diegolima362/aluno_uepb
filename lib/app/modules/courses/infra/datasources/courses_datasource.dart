import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';

import '../models/models.dart';

abstract class ICoursesDatasource {
  Future<List<CourseModel>> getCourses({String? id});
}

abstract class ICoursesLocalDatasource extends ICoursesDatasource {
  Future<Unit> saveCourses(List<CourseModel> courses);

  Future<Unit> saveRDM(Uint8List file);

  Future<String> readRDM();

  Future<List<CourseModel>> getTodaysClasses();
}

abstract class ICoursesRemoteDatasource extends ICoursesDatasource {
  Future<Option<Uint8List>> downloadRDM();
}
