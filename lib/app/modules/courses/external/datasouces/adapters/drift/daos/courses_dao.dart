import 'package:aluno_uepb/app/modules/courses/infra/models/models.dart';
import 'package:drift/drift.dart';

import '../drift_database.dart';
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

  Future<List<CourseModel>> get todayClasses async {
    final result = <CourseModel>[];

    final today = intToDay(DateTime.now().weekday);

    final schedules = await (select(db.schedulesTable)
          ..where((s) => s.day.lower().equals(today.toLowerCase()))
          ..orderBy([(t) => OrderingTerm(expression: t.time)]))
        .get();

    if (schedules.isEmpty) return result;

    for (final schedule in schedules) {
      final course = await (select(coursesTable)
            ..where((c) => c.id.equals(schedule.course)))
          .getSingleOrNull();

      if (course != null) {
        result.add(courseFromTable(course, [scheduleFromTable(schedule)]));
      }
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
