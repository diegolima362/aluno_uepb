import 'dart:convert';

import '../../domain/entities/entities.dart';

const _weekDaysMap = {
  'seg': 1,
  'ter': 2,
  'qua': 3,
  'qui': 4,
  'sex': 5,
  'sab': 6,
  'dom': 7,
};

class ScheduleModel extends ScheduleEntity {
  ScheduleModel({
    required String day,
    required String time,
    required String local,
  }) : super(day: day, local: local, time: time);

  ScheduleModel copyWith({
    String? day,
    String? time,
    String? local,
  }) {
    return ScheduleModel(
      day: day ?? this.day,
      time: time ?? this.time,
      local: local ?? this.local,
    );
  }

  int get weekDay => _weekDaysMap[day.substring(0, 3).toLowerCase()] ?? 1;

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'time': time,
      'local': local,
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      day: map['day'],
      time: map['time'],
      local: map['local'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleModel.fromJson(String source) =>
      ScheduleModel.fromMap(json.decode(source));

  @override
  String toString() => toMap().toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScheduleModel &&
        other.day == day &&
        other.time == time &&
        other.local == local;
  }

  @override
  int get hashCode => day.hashCode ^ time.hashCode ^ local.hashCode;
}
