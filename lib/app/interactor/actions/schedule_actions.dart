import 'package:result_dart/result_dart.dart';

import '../../injector.dart';
import '../atoms/schedule_atoms.dart';
import '../models/extensions.dart';
import '../models/schedule.dart';
import '../repositories/courses_repository.dart';

final _repository = injector.get<CoursesRepository>();

Future<void> fetchSchedule() async {
  setScheduleLoading(true);
  setScheduleResult(null);

  await _repository.fetchCourses().fold(
    (courses) {
      final schedule = <int, DailySchedule>{};

      for (int day = DateTime.monday; day < DateTime.sunday; day++) {
        final items = <ScheduleItem>[];
        for (final course in courses) {
          final professors = course.professors;
          final lessons = course.classesAtDay(day);
          for (final lesson in lessons) {
            items.add((course.name, lesson, professors));
          }
        }

        schedule[day] = (day, items);
      }

      setScheduleState(schedule);
    },
    (err) => setScheduleResult(Failure(err)),
  );

  setScheduleLoading(false);
}
