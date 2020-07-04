import 'package:erdm/models/schedule.dart';

class Course {
  final String id;
  final String title;
  final String instructor;
  final int ch;
  int absences;
  final List<Schedule> schedule;

  Course({
    this.id,
    this.title,
    this.instructor,
    this.ch,
    this.absences,
    this.schedule,
  });

  Map<String, dynamic> toMap() {
    final mapSchedules = List<Map<String, dynamic>>();
    this.schedule.forEach((element) => mapSchedules.add(element.toMap()));
    return {
      'id': this.id,
      'title': this.title,
      'instructor': this.instructor,
      'ch': this.ch,
      'absences': this.absences,
      'schedule': mapSchedules
    };
  }

  factory Course.fromMap(Map<dynamic, dynamic> map) {
    var scheduleObjsJson = map['schedule'] as List;

    List<Schedule> schedules = scheduleObjsJson
        .map((scheduleJson) => Schedule.fromMap(scheduleJson))
        .toList();

    return Course(
      id: map['id'] as String,
      title: map['title'] as String,
      instructor: map['instructor'] as String,
      ch: map['ch'] as int,
      absences: map['absences'] as int,
      schedule: schedules,
    );
  }

  @override
  String toString() =>
      '{ ${this.title}, ${this.instructor}, ${this.ch}, ${this.absences}, ${this.schedule} }';

  String startTimeAtDay(int day) {
    final schedule = scheduleAtDay(day);
    return schedule?.time ?? null;
  }

  Schedule scheduleAtDay(int day) {
    final schedules = this.schedule.where((e) => e.weekDay == day).toList();
    return schedules.isNotEmpty ? schedules[0] : null;
  }
}
