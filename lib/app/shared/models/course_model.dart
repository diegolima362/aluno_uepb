import 'package:intl/intl.dart';

import 'schedule_model.dart';

class CourseModel {
  final String id;
  final String name;
  final String professor;
  final int ch;
  final int absences;
  final int absencesLimit;
  List<ScheduleModel> schedule = <ScheduleModel>[];
  final String und1Grade;
  final String und2Grade;
  final String finalTest;

  CourseModel({
    this.id: '',
    this.name: '',
    this.professor: '',
    this.ch: 0,
    this.absences: 0,
    this.absencesLimit: 0,
    this.und1Grade: '',
    this.und2Grade: '',
    this.finalTest: '',
    List<ScheduleModel>? schedule,
  }) {
    if (schedule != null) this.schedule = schedule;
  }

  factory CourseModel.fromMap(Map<dynamic, dynamic> map) {
    List? scheduleMap = map['schedule'] as List?;

    if (scheduleMap == null) scheduleMap = [];

    List<ScheduleModel> schedules = scheduleMap
        .map((scheduleJson) => ScheduleModel.fromMap(scheduleJson))
        .toList();

    return CourseModel(
      id: map['id'] as String,
      name: map['name'] as String,
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

  bool hasClassAtDay(int day) => scheduleAtDay(day) != null;

  bool isCurrentClass(int weekDay) {
    bool _isCurrentClass = false;

    final now = DateTime.now();
    final today = weekDay == now.weekday;

    final result = scheduleAtDay(weekDay);

    if (result != null) {
      final currentHour = int.tryParse(DateFormat('H').format(now)) ?? 0;
      final classTime = int.tryParse(result.time.split(':')[0]) ?? 0;

      _isCurrentClass =
          today && (currentHour == classTime || currentHour == classTime + 1);
    }
    return _isCurrentClass;
  }

  ScheduleModel? scheduleAtDay(int day) {
    final schedules = this.schedule.where((e) => e.weekDay == day).toList();
    return schedules.isNotEmpty ? schedules[0] : null;
  }

  String? startTimeAtDay(int day) {
    final s = scheduleAtDay(day);
    return s?.time ?? null;
  }

  Map<String, dynamic> toMap() {
    final mapSchedules = <Map<String, dynamic>>[];
    this.schedule.forEach((e) => mapSchedules.add(e.toMap()));

    return {
      'id': this.id,
      'name': this.name,
      'professor': this.professor,
      'ch': this.ch,
      'absences': this.absences,
      'absencesLimit': this.absencesLimit,
      'schedule': mapSchedules,
      'finalTest': finalTest,
      'und1Grade': und1Grade,
      'und2Grade': und2Grade,
    };
  }

  @override
  String toString() =>
      '{ ${this.name}, ${this.professor}, ${this.ch}, ${this.absences}/${this.absencesLimit}, ${this.schedule} }';
}
