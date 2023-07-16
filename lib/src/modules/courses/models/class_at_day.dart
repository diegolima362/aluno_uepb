class ClassAtDay {
  final String startTime;
  final String endTime;
  final String local;
  final String localShort;

  final String course;
  final List<String> professors;

  ClassAtDay({
    required this.startTime,
    required this.endTime,
    required this.local,
    required this.localShort,
    required this.course,
    required this.professors,
  });
}

typedef ScheduleAtWeekDay = (int weekday, List<ClassAtDay> schedule);

extension ScheduleFormatter on ClassAtDay {
  String get formattedTime =>
      startTime + (endTime.isNotEmpty ? ' - $endTime' : '');

  String get formattedProfessors => professors.isEmpty
      ? ''
      : professors.first +
          (professors.length > 1 ? ' +${professors.length - 1}' : '');
}
