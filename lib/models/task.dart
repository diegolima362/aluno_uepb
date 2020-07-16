import 'package:flutter/foundation.dart';

class Task {
  Task({
    @required this.id,
    @required this.courseId,
    @required this.start,
    @required this.end,
    this.comment,
  });

  String id;
  String courseId;
  DateTime start;
  DateTime end;
  String comment;

  double get durationInHours =>
      end.difference(start).inMinutes.toDouble() / 60.0;

  factory Task.fromMap(Map<dynamic, dynamic> value, String id) {
    final int startMilliseconds = value['start'];
    final int endMilliseconds = value['end'];
    return Task(
      id: id,
      courseId: value['courseId'],
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      comment: value['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseId': courseId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
    };
  }
}
