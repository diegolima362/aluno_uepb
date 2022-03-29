import 'dart:convert';

import '../../domain/entities/history_entity.dart';

class HistoryModel extends HistoryEntity {
  HistoryModel({
    required String id,
    required String name,
    required String semester,
    required String cumulativeHours,
    required String grade,
    required String absences,
    required String status,
  }) : super(
          id: id,
          name: name,
          semester: semester,
          cumulativeHours: cumulativeHours,
          grade: grade,
          absences: absences,
          status: status,
        );

  HistoryModel copyWith({
    String? id,
    String? name,
    String? semester,
    String? cumulativeHours,
    String? grade,
    String? absences,
    String? status,
  }) {
    return HistoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      semester: semester ?? this.semester,
      cumulativeHours: cumulativeHours ?? this.cumulativeHours,
      grade: grade ?? this.grade,
      absences: absences ?? this.absences,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'semester': semester,
      'cumulativeHours': cumulativeHours,
      'grade': grade,
      'absences': absences,
      'status': status,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      semester: map['semester'] ?? '',
      cumulativeHours: map['cumulativeHours'] ?? '',
      grade: map['grade'] ?? '',
      absences: map['absences'] ?? '',
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryModel.fromJson(String source) =>
      HistoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HistoryModel(id: $id, name: $name, semester: $semester, cumulativeHours: $cumulativeHours, grade: $grade, absences: $absences, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HistoryModel &&
        other.id == id &&
        other.name == name &&
        other.semester == semester &&
        other.cumulativeHours == cumulativeHours &&
        other.grade == grade &&
        other.absences == absences &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        semester.hashCode ^
        cumulativeHours.hashCode ^
        grade.hashCode ^
        absences.hashCode ^
        status.hashCode;
  }
}
