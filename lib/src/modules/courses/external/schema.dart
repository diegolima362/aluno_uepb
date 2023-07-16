import 'package:isar/isar.dart';

import '../models/models.dart';

part 'schema.g.dart';

@Collection()
@Name("Course")
class IsarCourseModel {
  final Id id;
  String title;

  List<String> professors;

  String courseCode;
  String classId;

  List<IsarScheduleModel> schedule = [];

  List<IsarGradeModel> grades = [];

  int absences;
  int absenceLimit;
  int totalHours;
  int credits;

  IsarCourseModel({
    required this.id,
    this.title = '',
    this.professors = const [],
    this.courseCode = '',
    this.classId = '',
    this.schedule = const [],
    this.grades = const [],
    this.absences = 0,
    this.absenceLimit = 0,
    this.totalHours = 0,
    this.credits = 0,
  });

  Course toDomain() {
    return Course(
      id: id,
      title: title,
      professors: professors,
      courseCode: courseCode,
      classId: classId,
      schedule: schedule
          .map((e) => Schedule(
                weekday: e.weekday,
                startTime: e.startTime,
                endTime: e.endTime,
                local: e.local,
                localShort: e.localShort,
              ))
          .toList(),
      grades: grades
          .map((e) => Grade(
                value: e.value,
                weight: e.weight,
                label: e.label,
              ))
          .toList(),
      absences: absences,
      absenceLimit: absenceLimit,
      totalHours: totalHours,
      credits: credits,
    );
  }

  factory IsarCourseModel.fromDomain(Course model) {
    return IsarCourseModel(
      id: model.id,
      title: model.title,
      professors: model.professors,
      courseCode: model.courseCode,
      classId: model.classId,
      schedule: model.schedule
          .map((e) => IsarScheduleModel(
                weekday: e.weekday,
                startTime: e.startTime,
                endTime: e.endTime,
                local: e.local,
                localShort: e.localShort,
              ))
          .toList(),
      grades: model.grades
          .map((e) => IsarGradeModel(
                value: e.value,
                weight: e.weight,
                label: e.label,
              ))
          .toList(),
      absences: model.absences,
      absenceLimit: model.absenceLimit,
      totalHours: model.totalHours,
      credits: model.credits,
    );
  }
}

@embedded
@Name("Grade")
class IsarGradeModel {
  String value;
  String weight;
  String label;

  IsarGradeModel({
    this.value = '',
    this.weight = '',
    this.label = '',
  });
}

@embedded
@Name("Schedule")
class IsarScheduleModel {
  int weekday;
  String startTime;
  String endTime;
  String local;
  String localShort;

  IsarScheduleModel({
    this.weekday = DateTime.monday,
    this.startTime = '',
    this.endTime = '',
    this.local = '',
    this.localShort = '',
  });
}

@Collection()
@Name("History")
class IsarHistoryModel {
  final Id id;

  String name = '';
  List<String> professors = [];
  String code = '';

  @Index()
  String semester = '';

  String totalHours = '';
  String grade = '';
  String status = '';
  String type = '';
  String credits = '';

  IsarHistoryModel({
    required this.id,
    this.name = '',
    this.professors = const [],
    this.code = '',
    this.semester = '',
    this.totalHours = '',
    this.grade = '',
    this.status = '',
    this.type = '',
    this.credits = '',
  });

  History toDomain() {
    return History(
      id: id,
      name: name,
      professors: professors,
      code: code,
      semester: semester,
      totalHours: totalHours,
      grade: grade,
      status: status,
      type: type,
      credits: credits,
    );
  }

  factory IsarHistoryModel.fromDomain(History model) {
    return IsarHistoryModel(
      id: model.id,
      name: model.name,
      professors: model.professors,
      code: model.code,
      semester: model.semester,
      totalHours: model.totalHours,
      grade: model.grade,
      status: model.status,
      type: model.type,
      credits: model.credits,
    );
  }
}
