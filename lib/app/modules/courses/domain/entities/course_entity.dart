import 'schedule_entity.dart';

class CourseEntity {
  final String id;
  final String name;
  final String professor;
  final int duration;
  final int absences;
  final int absencesLimit;
  final List<ScheduleEntity> schedule;
  final String und1Grade;
  final String und2Grade;
  final String finalTest;

  CourseEntity({
    required this.id,
    required this.name,
    required this.professor,
    required this.duration,
    required this.absences,
    required this.absencesLimit,
    required this.und1Grade,
    required this.und2Grade,
    required this.finalTest,
    required this.schedule,
  });
}
