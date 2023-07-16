import 'package:asp/asp.dart';
import 'package:result_dart/result_dart.dart';

import '../../data/repositories/course_repository.dart';
import '../../models/class_at_day.dart';
import '../../models/extensions.dart';
import '../atoms/today_schedule_atom.dart';

class TodayScheduleReducer extends Reducer {
  final CourseRepository _repository;

  TodayScheduleReducer(
    this._repository,
  ) {
    on(() => [fetchTodayScheduleAction], _fetchSchedule);
  }

  void _fetchSchedule() async {
    todayScheduleLoadingState.value = true;
    todayScheduleResultState.value = null;

    final result = await _repository.fetchCourses();
    result.fold(
      (data) {
        final today = DateTime.now().weekday;
        final schedule = <ClassAtDay>[];

        final filtered = data.where((e) => e.scheduleAtDay(today).isNotEmpty);

        for (final course in filtered) {
          final schedules = course.scheduleAtDay(today);
          for (final s in schedules) {
            schedule.add(ClassAtDay(
              course: course.title,
              professors: course.professors,
              startTime: s.startTime,
              endTime: s.endTime,
              local: s.local,
              localShort: s.localShort,
            ));
          }
        }

        todayScheduleState.value = schedule;
      },
      (err) => todayScheduleResultState.value = Failure(err),
    );

    todayScheduleLoadingState.value = false;
  }
}
