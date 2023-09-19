import 'package:isar/isar.dart';
import 'package:result_dart/result_dart.dart';

import '../../../shared/domain/models/app_exception.dart';
import '../data/datasources/course_datasource.dart';
import '../models/models.dart';
import 'schema.dart';

class CourseIsarLocalDataSource implements CourseLocalDataSource {
  final Isar db;

  CourseIsarLocalDataSource(this.db);

  @override
  AsyncResult<List<Course>, AppException> fetchCourses() async {
    final data = (await db.isarCourseModels.where().findAll())
        .map((e) => e.toDomain())
        .toList();
    return Success(data);
  }

  @override
  AsyncResult<Course, AppException> fetchCourse(int id) async {
    final data = await db.isarCourseModels.get(id);
    if (data == null) {
      return Failure(AppException('Course not found'));
    }
    return Success(data.toDomain());
  }

  @override
  AsyncResult<Course, AppException> save(Course data) async {
    int id = -1;
    await db.writeTxn(() async {
      final toSave = IsarCourseModel.fromDomain(data);
      id = await db.isarCourseModels.put(toSave);
    });

    return fetchCourse(id);
  }

  @override
  AsyncResult<List<Course>, AppException> saveAll(List<Course> data) async {
    final ids = <int>[];

    await db.writeTxn(() async {
      final toSave = data.map(IsarCourseModel.fromDomain).toList();
      ids.addAll(await db.isarCourseModels.putAll(toSave));
    });

    final result = (await db.isarCourseModels.getAll(ids))
        .whereType<IsarCourseModel>()
        .map((e) => e.toDomain())
        .toList();
    return Success(result);
  }

  @override
  AsyncResult<Unit, AppException> clear() async {
    await db.writeTxn(() async {
      await db.isarCourseModels.clear();
    });

    return Success.unit();
  }
}
