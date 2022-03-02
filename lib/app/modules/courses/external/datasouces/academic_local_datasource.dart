import 'package:aluno_uepb/app/modules/courses/domain/errors/errors.dart';
import 'package:fpdart/fpdart.dart';

import '../../infra/datasources/academic_datasource.dart';
import '../../infra/models/models.dart';
import 'adapters/drift/drift_database.dart';

class AcademicLocalDatasource implements IAcademicLocalDatasource {
  final ContentDatabase db;

  AcademicLocalDatasource(this.db);

  @override
  Future<List<CourseModel>> getCourses() async {
    try {
      return await db.coursesDao.allCourses;
    } catch (e) {
      throw ServerError(message: 'LocalDatasource: ' + e.toString());
    }
  }

  @override
  Future<Unit> saveCourses(List<CourseModel> courses) async {
    try {
      await db.coursesDao.saveCourses(courses);
      return unit;
    } catch (e) {
      throw ServerError(message: 'LocalDatasource: ' + e.toString());
    }
  }

  @override
  Future<Option<ProfileModel>> getProfile() async {
    try {
      return Option.fromNullable(await db.profilesDao.profile);
    } catch (e) {
      throw ServerError(message: 'LocalDatasource: ' + e.toString());
    }
  }

  @override
  Future<Unit> saveProfile(ProfileModel profile) async {
    try {
      await db.profilesDao.saveProfile(profile);
      return unit;
    } catch (e) {
      throw ServerError(message: 'LocalDatasource: ' + e.toString());
    }
  }

  @override
  Future<List<HistoryModel>> getHistory() async {
    try {
      return await db.historyDao.fullHistory;
    } catch (e) {
      throw ServerError(message: 'LocalDatasource: ' + e.toString());
    }
  }

  @override
  Future<Unit> saveHistory(List<HistoryModel> history) async {
    try {
      await db.historyDao.saveHistory(history);
      return unit;
    } catch (e) {
      throw ServerError(message: 'LocalDatasource: ' + e.toString());
    }
  }
}
