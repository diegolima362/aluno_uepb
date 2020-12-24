import 'course_model.dart';

class WeekDayScheduleModel {
  final List<CourseModel> courses;
  final int weekDay;

  WeekDayScheduleModel({this.courses, this.weekDay});

  @override
  String toString() {
    return 'weekDay: ${this.weekDay} schedule: ${courses.toString()}';
  }
}
