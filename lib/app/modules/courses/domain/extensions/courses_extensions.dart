import '../entities/entities.dart';

extension ClassAtDay on CourseEntity {
  bool hasClassAtDay(int day) {
    for (var i in schedule) {
      if (i.weekDay == day) {
        return true;
      }
    }
    return false;
  }

  ScheduleEntity scheduleAtDay(int d) {
    return schedule.firstWhere((s) => s.weekDay == d);
  }

  bool get hasClassToday => hasClassAtDay(DateTime.now().weekday);

  List<ScheduleEntity> classesAtDay(int day) =>
      schedule.where((s) => s.weekDay == day).toList();

  ScheduleEntity get todayClass => classesAtDay(DateTime.now().weekday).first;
}

extension WeekDay on ScheduleEntity {
  static Map<int, String> daysIntMap = {
    1: 'Segunda-feira',
    2: 'Terça-feira',
    3: 'Quarta-feira',
    4: 'Quinta-feira',
    5: 'Sexta-feira',
  };

  static Map<String, int> weekDaysMap = {
    'seg': 1,
    'ter': 2,
    'qua': 3,
    'qui': 4,
    'sex': 5,
    'sab': 6,
    'dom': 7,
  };

  int get weekDay => weekDaysMap[day.substring(0, 3).toLowerCase()] ?? 1;
}
