import 'package:intl/intl.dart';

import 'schedule_model.dart';

class CourseModel {
  final String id;
  final String title;
  final String professor;
  final int ch;
  int absences;
  int absencesLimit;
  List<ScheduleModel> schedule;
  final String und1Grade;
  final String und2Grade;
  final String finalTest;

  CourseModel({
    this.id: '',
    this.title: '',
    this.professor: '',
    this.ch: 0,
    this.absences: 0,
    this.absencesLimit: 0,
    this.und1Grade: '',
    this.und2Grade: '',
    this.finalTest: '',
    this.schedule,
  }) {
    if (schedule == null) schedule = <ScheduleModel>[];
  }

  Map<String, dynamic> toMap() {
    final mapSchedules = <Map<String, dynamic>>[];
    this.schedule.forEach((e) => mapSchedules.add(e.toMap()));

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

  factory CourseModel.fromMap(Map<dynamic, dynamic> map) {
    List scheduleMap = map['schedule'] as List;

    if (scheduleMap == null) scheduleMap = [];

    List<ScheduleModel> schedules = scheduleMap
        .map((scheduleJson) => ScheduleModel.fromMap(scheduleJson))
        .toList();

    return CourseModel(
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

  ScheduleModel scheduleAtDay(int day) {
    final schedules = this.schedule.where((e) => e.weekDay == day).toList();
    return schedules.isNotEmpty ? schedules[0] : null;
  }

  bool get isCurrentClass {
    final now = DateTime.now();
    final _weekday = now.weekday;
    bool _isCurrentClass = false;

    if (scheduleAtDay(_weekday) != null) {
      final currentHour = int.tryParse(DateFormat('H').format(now)) ?? 0;
      final courseSchedule = scheduleAtDay(_weekday);
      final classTime = int.tryParse(courseSchedule?.time?.split(':')[0]) ?? 0;

      _isCurrentClass = _weekday == now.weekday &&
          (currentHour == classTime || currentHour == classTime + 1);
    }
    return _isCurrentClass;
  }
}
