import 'package:flutter/foundation.dart';

class Task {
  Task({
    @required this.title,
    @required this.id,
    @required this.courseId,
    @required this.courseTitle,
    @required this.date,
    this.isCompleted = false,
    this.comment,
    this.setReminder = false,
  });

  final String id;
  final String title;
  final String courseId;
  final String courseTitle;
  DateTime date;
  bool isCompleted;
  bool setReminder;
  String comment;

  factory Task.fromMap(Map<dynamic, dynamic> value) {
    final int startMilliseconds = value['date'];
    return Task(
      id: value['id'],
      title: value['title'] ?? '',
      courseId: value['courseId'],
      courseTitle: value['courseTitle'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      comment: value['comment'],
      isCompleted: value['isCompleted'] ?? false,
      setReminder: value['setReminder'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'date': date.millisecondsSinceEpoch,
      'comment': comment,
      'isCompleted': isCompleted,
      'setReminder': setReminder,
    };
  }

  @override
  String toString() {
    return 'id: $id courseId: $courseId date: $date comment: $comment';
  }
}
