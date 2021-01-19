import 'package:flutter/foundation.dart';

class HistoryEntryModel {
  final String id;
  final String name;
  final String semester;
  final double grade;
  final String status;
  final int ch;
  final int absences;
  final String observation;

  HistoryEntryModel({
    @required this.id,
    @required this.name,
    this.semester,
    this.grade,
    this.status,
    this.ch,
    this.absences,
    this.observation,
  });

  factory HistoryEntryModel.fromMap(Map<dynamic, dynamic> map) {
    return HistoryEntryModel(
      id: map['id'],
      name: map['name'],
      semester: map['semester'],
      observation: map['observation'],
      ch: int.tryParse(map['ch']) ?? 0,
      grade: double.tryParse(map['grade']) ?? 0.0,
      absences: int.tryParse(map['absences']) ?? 0,
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'semester': semester,
      'grade': grade.toString(),
      'status': status,
      'ch': ch.toString(),
      'absences': absences.toString(),
      'observation': observation,
    };
  }

  String toString() {
    return "{ 'id': $id, 'name': $name, 'semester': $semester, 'grade': 'grade', 'status': $status, 'ch': $ch, 'absences': $absences, 'observation': $observation }";
  }
}
