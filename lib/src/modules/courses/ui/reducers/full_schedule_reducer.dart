import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../data/repositories/course_repository.dart';
import '../../models/class_at_day.dart';
import '../../models/extensions.dart';
import '../atoms/full_schedule_atom.dart';

class ScheduleReducer extends Reducer {
  final CourseRepository _repository;

  ScheduleReducer(this._repository) {
    on(() => [fetchFullScheduleAction], _fetchSchedule);
  }

  void _fetchSchedule() async {
    fullScheduleLoadingState.value = true;
    fullScheduleResultState.value = null;

    final result = await _repository.fetchCourses();
    result.fold(
      (data) {
        final schedule = <(int, List<ClassAtDay>)>[];

        for (int day = DateTime.monday; day < DateTime.sunday; day++) {
          final filtered = data.where((e) => e.hasClassAtDay(day));
          final scheduleAtDay = <ClassAtDay>[];

          for (final course in filtered) {
            final schedules = course.scheduleAtDay(day);
            for (final s in schedules) {
              scheduleAtDay.add(ClassAtDay(
                course: course.title,
                professors: course.professors,
                startTime: s.startTime,
                endTime: s.endTime,
                local: s.local,
                localShort: s.localShort,
              ));
            }
          }

          schedule.add((day, scheduleAtDay));
        }

        fullScheduleState.value = schedule;
      },
      (err) => fullScheduleResultState.value = Failure(err),
    );

    fullScheduleLoadingState.value = false;
  }
}
