import 'dart:io';
import 'dart:typed_data';

import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;

import '../../infra/datasources/courses_datasource.dart';
import '../../infra/models/models.dart';

class CoursesLocalDatasource implements ICoursesLocalDatasource {
  final AppDriftDatabase db;

  CoursesLocalDatasource(this.db);

  @override
  Future<List<CourseModel>> getCourses({String? id}) async {
    return await db.coursesDao.getCourses(id: id);
  }

  @override
  Future<List<CourseModel>> getTodaysClasses() async {
    return await db.coursesDao.todayClasses;
  }

  @override
  Future<Unit> saveCourses(List<CourseModel> courses) async {
    await db.coursesDao.saveCourses(courses);
    return unit;
  }

  Future<String> getPathToFile(String fileName) async {
    final path = p.join((await pp.getApplicationDocumentsDirectory()).path,
        'aluno_uepb', 'downloads');

    final dir = Directory(path);
    if (!await dir.exists()) {
      await Directory(path).create(recursive: true);
    }

    return p.join(path, fileName);
  }

  @override
  Future<String> readRDM() async {
    final path = await getPathToFile('rdm.html');
    final f = File(path);

    if (await f.exists()) {
      return path;
    } else {
      return '';
    }
  }

  @override
  Future<Unit> saveRDM(Uint8List file) async {
    final path = await getPathToFile('rdm.html');
    final f = File(path);

    await f.writeAsBytes(file);

    return unit;
  }
}
