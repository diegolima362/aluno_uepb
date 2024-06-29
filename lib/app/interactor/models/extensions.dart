import 'package:intl/intl.dart';

import '../../core/extensions/extensions.dart';
import 'course.dart';
import 'schedule.dart';

extension Formater on Lesson {
  String get dayOfWeek => DateFormat.E('pt_BR')
      .format(
        DateTime.now().subtract(
          Duration(
            days: DateTime.now().weekday - weekday,
          ),
        ),
      )
      .capitalFirst;
}

extension ClassesAtDay on Course {
  bool hasClassAtDay(int day) {
    for (var i in schedule) {
      if (i.weekday == day) {
        return true;
      }
    }
    return false;
  }

  List<Lesson> scheduleAtDay(int d) {
    return schedule.where((s) => s.weekday == d).toList();
  }

  bool get hasClassToday => hasClassAtDay(DateTime.now().weekday);

  List<Lesson> classesAtDay(int day) =>
      schedule.where((s) => s.weekday == day).toList();

  Lesson get todayClass => classesAtDay(DateTime.now().weekday).first;
}
