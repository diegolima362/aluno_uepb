import 'package:aluno_uepb/app/modules/courses/infra/models/models.dart';

import '../drift_database.dart';

ProfileModel profileFromTable(Profiles profile) {
  return ProfileModel(
    register: profile.register,
    name: profile.name,
    program: profile.program,
    campus: profile.campus,
    cra: profile.cra,
    cumulativeHours: profile.cumulativeHours,
  );
}

ProfilesTableCompanion profileToTable(ProfileModel profile) {
  return ProfilesTableCompanion.insert(
    register: profile.register,
    name: profile.name,
    program: profile.program,
    campus: profile.campus,
    cra: profile.cra,
    cumulativeHours: profile.cumulativeHours,
  );
}

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

HistoryModel historyFromTable(History history) {
  return HistoryModel(
    id: history.id,
    name: history.name,
    semester: history.semester,
    cumulativeHours: history.cumulativeHours,
    grade: history.grade,
    absences: history.absences,
    status: history.status,
  );
}

HistoryTableCompanion historyToTable(HistoryModel history) {
  return HistoryTableCompanion.insert(
    id: history.id,
    name: history.name,
    semester: history.semester,
    cumulativeHours: history.cumulativeHours,
    grade: history.grade,
    absences: history.absences,
    status: history.status,
  );
}
