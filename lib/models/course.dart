import 'package:erdm/models/schedule.dart';

class Course {
  final String title;
  final String instructor;
  final int ch;
  int absences;
  final List<Schedule> schedule;

  Course({this.title, this.instructor, this.ch, this.absences, this.schedule});

  Map<String, dynamic> toJson() => {
        'title': this.title,
        'instructor': this.instructor,
        'ch': this.ch,
        'absences': this.absences,
        'schedule': this.schedule
      };

  factory Course.fromJson(dynamic json) {
    var scheduleObjsJson = json['schedule'] as List;

    List<Schedule> schedules = scheduleObjsJson
        .map((scheduleJson) => Schedule.fromJson(scheduleJson))
        .toList();

    return Course(
      title: json['title'] as String,
      instructor: json['instructor'] as String,
      ch: json['ch'] as int,
      absences: json['absences'] as int,
      schedule: schedules,
    );
  }

  @override
  String toString() =>
      '{ ${this.title}, ${this.instructor}, ${this.ch}, ${this.absences}, ${this.schedule} }';
}
