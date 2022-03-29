import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:aluno_uepb/app/modules/courses/infra/models/models.dart';

CourseModel courseFromTable(Courses course, List<ScheduleModel> schedule) {
  return CourseModel(
    id: course.id,
    name: course.name,
    professor: course.professor,
    duration: course.duration,
    absences: course.absences,
    absencesLimit: course.absencesLimit,
    finalTest: course.finalTest,
    und1Grade: course.und1Grade,
    und2Grade: course.und2Grade,
    scheduleModel: schedule,
  );
}

CoursesTableCompanion courseToTalbe(CourseModel course) {
  return CoursesTableCompanion.insert(
    id: course.id,
    name: course.name,
    professor: course.professor,
    finalTest: course.finalTest,
    und1Grade: course.und1Grade,
    und2Grade: course.und2Grade,
    duration: course.duration,
    absences: course.absences,
    absencesLimit: course.absencesLimit,
  );
}

ScheduleModel scheduleFromTable(Schedules schedule) {
  return ScheduleModel(
    day: schedule.day,
    time: schedule.time,
    local: schedule.local,
  );
}

SchedulesTableCompanion scheduleToTable(ScheduleModel schedule, String id) {
  return SchedulesTableCompanion.insert(
    day: schedule.day,
    local: schedule.local,
    time: schedule.time,
    course: id,
  );
}
