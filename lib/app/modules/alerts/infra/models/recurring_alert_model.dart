import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/recurring_alert_entity.dart';

class AlertModel extends RecurringAlertEntity {
  AlertModel({
    required int id,
    required String course,
    required String title,
    required TimeOfDay time,
    required List<int> days,
  }) : super(
          id: id,
          course: course,
          title: title,
          time: time,
          days: days,
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course': course,
      'title': title,
      'time': '${time.hour}:${time.minute}',
      'days': days,
    };
  }

  factory AlertModel.fromMap(Map<String, dynamic> map) {
    final text = (map['time'] as String?)
        ?.split(':')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    final time = TimeOfDay(hour: text?[0] ?? 0, minute: text?[1] ?? 0);

    return AlertModel(
      id: map['id']?.toInt() ?? 0,
      course: map['course'] ?? '',
      title: map['title'] ?? '',
      time: time,
      days: map['days'],
    );
  }

  factory AlertModel.fromEntity(RecurringAlertEntity alert) => AlertModel(
        id: alert.id,
        course: alert.course,
        title: alert.title,
        time: alert.time,
        days: alert.days,
      );

  String toJson() => json.encode(toMap());

  factory AlertModel.fromJson(String source) =>
      AlertModel.fromMap(json.decode(source));

  AlertModel copyWith({
    int? id,
    String? course,
    List<int>? days,
    String? title,
    TimeOfDay? time,
  }) {
    return AlertModel(
      id: id ?? this.id,
      course: course ?? this.course,
      days: days ?? this.days,
      title: title ?? this.title,
      time: time ?? this.time,
    );
  }

  @override
  String toString() => toMap().toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecurringAlertEntity &&
        other.id == id &&
        other.course == course &&
        listEquals(other.days, days) &&
        other.title == title &&
        other.time == time;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        course.hashCode ^
        days.hashCode ^
        title.hashCode ^
        time.hashCode;
  }
}
