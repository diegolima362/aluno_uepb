import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:aluno_uepb/app/modules/courses/infra/models/models.dart';
import 'package:drift/drift.dart';

import 'mappers.dart';

part 'courses_dao.g.dart';

final dayToInt = {
  'Segunda': 1,
  'Terça': 2,
  'Quarta': 3,
  'Quinta': 4,
  'Sexta': 5,
  'Sábado': 6,
  'Domingo': 7,
};

final _intToDay = {
  1: 'Segunda',
  2: 'Terça',
  3: 'Quarta',
  4: 'Quinta',
  5: 'Sexta',
  6: 'Sábado',
  7: 'Domingo',
};

String intToDay(int val) => _intToDay[val] ?? 'Not found';

@DriftAccessor(tables: [CoursesTable])
class CoursesDao extends DatabaseAccessor<AppDriftDatabase>
    with _$CoursesDaoMixin {
  CoursesDao(AppDriftDatabase db) : super(db);

  Future<List<CourseModel>> getCourses({String? id}) async {
    final result = <CourseModel>[];
    List<Courses> courses;

    if (id != null) {
      courses = await (db.select(db.coursesTable)
            ..where((c) => c.id.equals(id))
            ..orderBy([(c) => OrderingTerm(expression: c.name)]))
          .get();
    } else {
      courses = await (db.select(db.coursesTable)
            ..orderBy([(c) => OrderingTerm(expression: c.name)]))
          .get();
    }

    for (final c in courses) {
      final schedule = await (select(db.schedulesTable)
            ..where((s) => s.course.equals(c.id)))
          .map(scheduleFromTable)
          .get();

      result.add(courseFromTable(c, schedule));
    }

    return result;
  }

  Future<List<CourseModel>> get todayClasses async {
    final result = <CourseModel>[];

    final today = intToDay(DateTime.now().weekday);

    final ids = await (select(db.schedulesTable)
          ..where((s) => s.day.lower().equals(today.toLowerCase())))
        .map((s) => s.course)
        .get();

    if (ids.isEmpty) return result;

    for (final id in ids) {
      final course = await (select(coursesTable)..where((c) => c.id.equals(id)))
          .getSingleOrNull();

      final schedule = await (select(db.schedulesTable)
            ..where((s) => s.course.equals(course?.id)))
          .map(scheduleFromTable)
          .get();

      if (course != null) {
        result.add(courseFromTable(course, schedule));
      }
    }

    return result;
  }

  Future<void> saveCourses(List<CourseModel> courses) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(
          db.coursesTable, courses.map(courseToTalbe));
    });

    await db.delete(db.schedulesTable).go();

    for (final course in courses) {
      await batch((batch) {
        batch.insertAllOnConflictUpdate(
          db.schedulesTable,
          course.scheduleModel.map((s) => scheduleToTable(s, course.id)),
        );
      });
    }
  }
}
