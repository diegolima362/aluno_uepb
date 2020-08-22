import 'package:flutter/foundation.dart';

class Task {
  Task({
    @required this.id,
    @required this.courseId,
    @required this.date,
    this.comment,
  });

  String id;
  String courseId;
  DateTime date;
  String comment;

  factory Task.fromMap(Map<dynamic, dynamic> value, String id) {
    final int startMilliseconds = value['start'];
    return Task(
      id: id,
      courseId: value['courseId'],
      date: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      comment: value['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseId': courseId,
      'date': date.millisecondsSinceEpoch,
      'comment': comment,
    };
  }
}
