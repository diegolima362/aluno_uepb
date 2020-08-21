import 'package:intl/intl.dart';

import 'schedule.dart';

class Course {
  final String id;
  final String title;
  final String professor;
  final int ch;
  int absences;
  int absencesLimit;
  final List<Schedule> schedule;
  final String und1Grade;
  final String und2Grade;
  final String finalTest;

  Course({
    this.id,
    this.title,
    this.professor,
    this.ch,
    this.absences,
    this.absencesLimit,
    this.und1Grade,
    this.und2Grade,
    this.finalTest,
    this.schedule,
  });

  Map<String, dynamic> toMap() {
    final mapSchedules = List<Map<String, dynamic>>();
    this.schedule.forEach((element) => mapSchedules.add(element.toMap()));
    return {
      'id': this.id,
      'title': this.title,
      'professor': this.professor,
      'ch': this.ch,
      'absences': this.absences,
      'absencesLimit': this.absencesLimit,
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
      professor: map['professor'] as String,
      ch: map['ch'] as int,
      absences: map['absences'] as int,
      absencesLimit: map['absencesLimit'] as int,
      schedule: schedules,
      finalTest: map['finalTest'] as String,
      und1Grade: map['und1Grade'] as String,
      und2Grade: map['und2Grade'] as String,
    );
  }

  @override
  String toString() =>
      '{ ${this.title}, ${this.professor}, ${this.ch}, ${this.absences}/${this.absencesLimit}, ${this.schedule} }';

  String startTimeAtDay(int day) {
    final schedule = scheduleAtDay(day);
    return schedule?.time ?? null;
  }

  Schedule scheduleAtDay(int day) {
    final schedules = this.schedule.where((e) => e.weekDay == day).toList();
    return schedules.isNotEmpty ? schedules[0] : null;
  }

  bool get isCurrentClass {
    final now = DateTime.now();
    final _weekday = now.weekday;
    var _isCurrentClass = false;

    if (scheduleAtDay(_weekday) != null) {
      final currentHour = int.tryParse(DateFormat('H').format(now));
      final courseSchedule = scheduleAtDay(_weekday);
      final classTime = int.tryParse(courseSchedule?.time?.split(':')[0]);
      _isCurrentClass = _weekday == now.weekday &&
          (currentHour == classTime || currentHour == classTime + 1);
    }
    return _isCurrentClass;
  }
}
