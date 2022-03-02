import 'package:aluno_uepb/app/modules/courses/infra/models/models.dart';
import 'package:drift/drift.dart';

import '../drift_database.dart';
import 'mappers.dart';

part 'courses_dao.g.dart';

@DriftAccessor(tables: [CoursesTable])
class CoursesDao extends DatabaseAccessor<ContentDatabase>
    with _$CoursesDaoMixin {
  CoursesDao(ContentDatabase db) : super(db);

  Future<List<CourseModel>> get allCourses async {
    final result = <CourseModel>[];
    final courses = await select(db.coursesTable).get();

    for (final c in courses) {
      final schedule = await (select(db.schedulesTable)
            ..where((s) => s.course.equals(c.id)))
          .map(scheduleFromTable)
          .get();

      result.add(courseFromTable(c, schedule));
    }

    return result;
  }

  Future<void> saveCourses(List<CourseModel> courses) async {
    await batch((batch) {
      batch.insertAll(db.coursesTable, courses.map(courseToTalbe));
    });

    for (final course in courses) {
      await batch((batch) {
        batch.insertAll(
          db.schedulesTable,
          course.scheduleModel.map((s) => scheduleToTable(s, course.id)),
        );
      });
    }
  }
}
