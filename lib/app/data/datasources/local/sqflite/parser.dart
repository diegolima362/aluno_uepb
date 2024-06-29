import 'dart:convert';

import '../../../../interactor/models/models.dart';

Grade parseGrade(Map<String, Object?> map) {
  return Grade.fromMap(map);
}

Lesson parseSchedule(Map<String, Object?> map) {
  return Lesson.fromMap(map);
}

Course parseCourse(Map<String, Object?> result) {
  Map<String, dynamic> courseInfo = {
    'code': result['code'],
    'semester': result['semester'],
    'name': result['name'],
    'grades': [],
    'schedules': [],
    'professors': (result['professors'] as String? ?? '').split(';'),
    'classId': result['classId'],
    'absences': result['absences'],
    'absenceLimit': result['absenceLimit'],
    'totalHours': result['totalHours'],
    'credits': result['credits'],
  };

  final gradesJson = jsonDecode(result['grade_list'] as String? ?? '[]');
  final schedulesJson = jsonDecode(result['schedule_list'] as String? ?? '[]');

  final course = Course.fromMap(courseInfo);

  final grades = <Grade>[];
  for (final item in gradesJson) {
    grades.add(Grade.fromMap(item));
  }

  final schedules = <Lesson>[];
  for (final item in schedulesJson) {
    schedules.add(Lesson.fromMap(item));
  }

  return course.copyWith(
    grades: grades,
    schedule: schedules,
  );
}

HistoryEntry parseHistory(Map<String, Object?> result) {
  Map<String, dynamic> map = {
    "code": result['code'],
    "name": result['name'],
    "credits": result['credits'],
    "professors": (result['professors'] as String? ?? '').split(';'),
    "grade": result['grade'],
    "semester": result['semester'],
    "status": result['status'],
    "totalHours": result['totalHours'],
    "type": result['type'],
  };

  return HistoryEntry.fromMap(map);
}
