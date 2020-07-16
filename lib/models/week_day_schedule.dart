import 'package:cau3pb/models/course.dart';

class WeekDaySchedule {
  final List<Course> courses;
  final int weekDay;

  WeekDaySchedule({this.courses, this.weekDay});

  @override
  String toString() {
    return 'weekDay: ${this.weekDay} schedule: ${courses.toString()}';
  }
}