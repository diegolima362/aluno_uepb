import 'dart:convert';

import '../../domain/entities/course_entity.dart';
import 'schedule_model.dart';

class CourseModel extends CourseEntity {
  final List<ScheduleModel> scheduleModel;

  CourseModel({
    required String id,
    required String name,
    required String professor,
    required int duration,
    required int absences,
    required int absencesLimit,
    required String finalTest,
    required String und1Grade,
    required String und2Grade,
    required this.scheduleModel,
  }) : super(
          absences: absences,
          absencesLimit: absencesLimit,
          duration: duration,
          finalTest: finalTest,
          id: id,
          name: name,
          professor: professor,
          schedule: scheduleModel,
          und1Grade: und1Grade,
          und2Grade: und2Grade,
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'professor': professor,
      'duration': duration,
      'absences': absences,
      'absencesLimit': absencesLimit,
      'schedule': scheduleModel.map((x) => x.toMap()).toList(),
      'und1Grade': und1Grade,
      'und2Grade': und2Grade,
      'finalTest': finalTest,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'],
      name: map['name'],
      professor: map['professor'],
      duration: map['duration'],
      absences: map['absences'],
      absencesLimit: map['absencesLimit'],
      scheduleModel: List<ScheduleModel>.from(
        map['schedule']?.map((x) => ScheduleModel.fromMap(x)),
      ),
      und1Grade: map['und1Grade'],
      und2Grade: map['und2Grade'],
      finalTest: map['finalTest'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseModel.fromJson(String source) =>
      CourseModel.fromMap(json.decode(source));

  CourseModel copyWith({
    String? id,
    String? name,
    String? professor,
    int? duration,
    int? absences,
    int? absencesLimit,
    List<ScheduleModel>? scheduleModel,
    String? und1Grade,
    String? und2Grade,
    String? finalTest,
  }) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      professor: professor ?? this.professor,
      duration: duration ?? this.duration,
      absences: absences ?? this.absences,
      absencesLimit: absencesLimit ?? this.absencesLimit,
      scheduleModel: scheduleModel ?? this.scheduleModel,
      und1Grade: und1Grade ?? this.und1Grade,
      und2Grade: und2Grade ?? this.und2Grade,
      finalTest: finalTest ?? this.finalTest,
    );
  }

  @override
  String toString() {
    return 'CourseModel(id: $id, name: $name, professor: $professor, duration: $duration, absences: $absences, absencesLimit: $absencesLimit, schedule: $scheduleModel, und1Grade: $und1Grade, und2Grade: $und2Grade, finalTest: $finalTest)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CourseModel &&
        other.id == id &&
        other.name == name &&
        other.professor == professor &&
        other.duration == duration &&
        other.absences == absences &&
        other.absencesLimit == absencesLimit &&
        other.scheduleModel == scheduleModel &&
        other.und1Grade == und1Grade &&
        other.und2Grade == und2Grade &&
        other.finalTest == finalTest;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        professor.hashCode ^
        duration.hashCode ^
        absences.hashCode ^
        absencesLimit.hashCode ^
        scheduleModel.hashCode ^
        und1Grade.hashCode ^
        und2Grade.hashCode ^
        finalTest.hashCode;
  }
}
