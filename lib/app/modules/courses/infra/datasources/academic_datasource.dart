import 'package:fpdart/fpdart.dart';

import '../models/models.dart';

abstract class IAcademicDatasource {
  Future<List<CourseModel>> getCourses();

  Future<Option<ProfileModel>> getProfile();

  Future<List<HistoryModel>> getHistory();
}

abstract class IAcademicLocalDatasource extends IAcademicDatasource {
  Future<Unit> saveCourses(List<CourseModel> courses);

  Future<Unit> saveProfile(ProfileModel profile);

  Future<Unit> saveHistory(List<HistoryModel> history);

  Future<List<CourseModel>> getTodaysClasses();
}

abstract class IAcademicRemoteDatasource extends IAcademicDatasource {}
