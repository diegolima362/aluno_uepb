import 'package:erdm/models/course.dart';

class CourseListFilter {
  static List<Map> todayClassesList(List items) {
    final today = DateTime.now();
    final todayClasses = List<Course>();
    final weekday = today.weekday;

    final courses = items.map((e) => Course.fromMap(e)).toList();

    courses.forEach((element) {
      final days = element.schedule.map((e) => e.weekDay).toList();
      final contains = days.indexOf(weekday);
      if (contains != -1) todayClasses.add(element);
    });

    todayClasses.sort((a, b) =>
        a.startTimeAtDay(weekday).compareTo(b.startTimeAtDay(weekday)));

    return todayClasses.map((e) => e.toMap()).toList();
  }
}
