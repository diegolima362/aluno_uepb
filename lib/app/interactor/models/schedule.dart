import '../../core/extensions/datetime_extensions.dart';

class Lesson {
  final int weekday;
  final String startTime;
  final String endTime;
  final String local;
  final String localShort;

  Lesson({
    this.weekday = DateTime.monday,
    this.startTime = '',
    this.endTime = '',
    this.local = '',
    this.localShort = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'weekday': weekday,
      'startTime': startTime,
      'endTime': endTime,
      'local': local,
      'localShort': localShort,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      weekday: map['weekday'] ?? DateTime.monday,
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      local: map['local'] ?? '',
      localShort: map['localShort'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Lesson{weekday: $weekday, startTime: $startTime, endTime: $endTime, local: $local, localShort: $localShort}';
  }
}

typedef DailySchedule = (int weekDay, List<ScheduleItem> schedule);

extension DailyScheduleFormatter on DailySchedule {
  int get weekDay => $1;

  String get formattedWeekDay => intToWeekDayEEEE(weekDay);

  List<ScheduleItem> get schedule => $2;
}

typedef ScheduleItem = (String course, Lesson lesson, List<String> professors);

extension ScheduleFormatter on ScheduleItem {
  String get course => $1;

  int weekday() => $2.weekday;

  String get startTime => $2.startTime;

  String get endTime => $2.endTime;

  String get local => $2.local;

  String get localShort => $2.localShort;

  String get formattedTime =>
      startTime + (endTime.isNotEmpty ? ' - $endTime' : '');

  List<String> get professors => $3;

  String get formattedProfessors => professors.isEmpty
      ? ''
      : professors.first +
          (professors.length > 1 ? ' +${professors.length - 1}' : '');
}
