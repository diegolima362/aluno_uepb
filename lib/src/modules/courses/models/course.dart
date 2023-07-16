class Course {
  final int id;
  final String title;
  final List<String> professors;
  final String courseCode;
  final String classId;
  final List<Schedule> schedule;
  final List<Grade> grades;
  final int absences;
  final int absenceLimit;
  final int totalHours;
  final int credits;

  Course({
    this.id = 0,
    required this.title,
    required this.professors,
    required this.courseCode,
    required this.classId,
    required this.absences,
    required this.absenceLimit,
    required this.totalHours,
    required this.credits,
    this.schedule = const [],
    this.grades = const [],
  });

  Course copyWith({
    int? id,
    String? title,
    List<String>? professors,
    String? courseCode,
    String? classId,
    List<Schedule>? schedule,
    List<Grade>? grades,
    int? absences,
    int? absenceLimit,
    int? totalHours,
    int? credits,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      professors: professors ?? this.professors,
      courseCode: courseCode ?? this.courseCode,
      classId: classId ?? this.classId,
      schedule: schedule ?? this.schedule,
      grades: grades ?? this.grades,
      absences: absences ?? this.absences,
      absenceLimit: absenceLimit ?? this.absenceLimit,
      totalHours: totalHours ?? this.totalHours,
      credits: credits ?? this.credits,
    );
  }
}

class Grade {
  final String value;
  final String weight;
  final String label;

  Grade({
    this.value = '',
    this.weight = '',
    this.label = '',
  });
}

class Schedule {
  final int weekday;
  final String startTime;
  final String endTime;
  final String local;
  final String localShort;

  Schedule({
    this.weekday = DateTime.monday,
    this.startTime = '',
    this.endTime = '',
    this.local = '',
    this.localShort = '',
  });
}
