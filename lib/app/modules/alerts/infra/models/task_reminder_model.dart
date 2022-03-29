import 'dart:convert';

import '../../domain/entities/task_reminder_entity.dart';

class ReminderModel extends TaskReminderEntity {
  ReminderModel({
    required int id,
    required String course,
    required String title,
    required String subject,
    required String body,
    required DateTime time,
    required bool notify,
    required bool completed,
  }) : super(
          id: id,
          course: course,
          title: title,
          subject: subject,
          body: body,
          time: time,
          notify: notify,
          completed: completed,
        );

  factory ReminderModel.fromEntity(TaskReminderEntity entity) => ReminderModel(
        id: entity.id,
        course: entity.course,
        title: entity.title,
        subject: entity.subject,
        body: entity.body,
        time: entity.time,
        notify: entity.notify,
        completed: entity.completed,
      );

  ReminderModel copyWith({
    int? id,
    String? course,
    String? title,
    String? subject,
    String? body,
    DateTime? time,
    bool? notify,
    bool? completed,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      course: course ?? this.course,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      time: time ?? this.time,
      notify: notify ?? this.notify,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course': course,
      'title': title,
      'subject': subject,
      'body': body,
      'time': time.millisecondsSinceEpoch,
      'notify': notify,
      'completed': completed,
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id']?.toInt() ?? 0,
      course: map['course'] ?? '',
      title: map['title'] ?? '',
      subject: map['subject'] ?? '',
      body: map['body'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      notify: map['notify'] ?? false,
      completed: map['completed'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReminderModel.fromJson(String source) =>
      ReminderModel.fromMap(json.decode(source));

  @override
  String toString() => toMap().toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReminderModel &&
        other.id == id &&
        other.course == course &&
        other.title == title &&
        other.subject == subject &&
        other.body == body &&
        other.time == time &&
        other.notify == notify &&
        other.completed == completed;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        course.hashCode ^
        title.hashCode ^
        subject.hashCode ^
        body.hashCode ^
        time.hashCode ^
        notify.hashCode ^
        completed.hashCode;
  }
}
