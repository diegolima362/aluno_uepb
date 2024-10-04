import 'schedule.dart';

class Course {
  final String code;
  final String name;
  final String semester ;
  final List<String> professors;
  final String classId;
  final List<Lesson> schedule;
  final List<Grade> grades;
  final int absences;
  final int absenceLimit;
  final int totalHours;
  final int credits;

  Course({
    required this.code,
    required this.name,
    required this.semester,
    required this.professors,
    required this.classId,
    required this.absences,
    required this.absenceLimit,
    required this.totalHours,
    required this.credits,
    this.schedule = const [],
    this.grades = const [],
  });

  Course copyWith({
    String? code,
    String? name,
    String? semester,
    String? classId,
    List<String>? professors,
    List<Lesson>? schedule,
    List<Grade>? grades,
    int? absences,
    int? absenceLimit,
    int? totalHours,
    int? credits,
  }) {
    return Course(
      code: code ?? this.code,
      name: name ?? this.name,
      semester: semester ?? this.semester,
      professors: professors ?? this.professors,
      classId: classId ?? this.classId,
      schedule: schedule ?? this.schedule,
      grades: grades ?? this.grades,
      absences: absences ?? this.absences,
      absenceLimit: absenceLimit ?? this.absenceLimit,
      totalHours: totalHours ?? this.totalHours,
      credits: credits ?? this.credits,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'semester': semester,
      'professors': professors,
      'classId': classId,
      'schedule': schedule.map((x) => x.toMap()).toList(),
      'grades': grades.map((x) => x.toMap()).toList(),
      'absences': absences,
      'absenceLimit': absenceLimit,
      'totalHours': totalHours,
      'credits': credits,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      semester: map['semester'] ?? '',
      professors: List<String>.from(map['professors'] ?? const []),
      classId: map['classId'] ?? '',
      schedule: List<Lesson>.from(
          map['schedule']?.map((x) => Lesson.fromMap(x)) ?? const []),
      grades: List<Grade>.from(
          map['grades']?.map((x) => Grade.fromMap(x)) ?? const []),
      absences: map['absences'] ?? 0,
      absenceLimit: map['absenceLimit'] ?? 0,
      totalHours: map['totalHours'] ?? 0,
      credits: map['credits'] ?? 0,
    );
  }



  @override
  String toString() {
    return 'Code: $code, name: $name, semester: $semester, professors: $professors, classId: $classId, schedule: $schedule, grades: $grades, absences: $absences, absenceLimit: $absenceLimit, totalHours: $totalHours, credits: $credits}';
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

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'weight': weight,
      'label': label,
    };
  }

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      value: map['value'] ?? '',
      weight: map['weight'] ?? '',
      label: map['label'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Grade{value: $value, weight: $weight, label: $label}';
  }
}
