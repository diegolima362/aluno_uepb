import 'dart:convert';

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String payload;
  final DateTime? dateTime;
  final int? weekday;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    this.weekday,
    this.dateTime,
  });

  factory NotificationModel.fromMap(Map<dynamic, dynamic> value) {
    final int date = int.tryParse(value['dateTime']) ??
        DateTime.now().millisecondsSinceEpoch;

    return NotificationModel(
      id: value['id'],
      title: value['title'],
      body: value['body'],
      payload: value['payload'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(date),
      weekday: value['weekDay'],
    );
  }

  bool get weekly {
    Map map = json.decode(payload);

    return map['type'] != null && map['type'] == 'weekly';
  }

  bool get taskReminder {
    Map map = json.decode(payload);
    return map['type'] != null && map['type'] == 'task';
  }

  String get courseId {
    Map map = json.decode(payload);
    return map['courseId'];
  }

  factory NotificationModel.fromPendingNotification(
      Map<dynamic, dynamic> value) {
    Map map = json.decode(value['payload']);
    int dateValue =
        int.tryParse(map['date']) ?? DateTime.now().millisecondsSinceEpoch;
    final date = DateTime.fromMillisecondsSinceEpoch(dateValue);

    int _weekDay = value['weekDay'] ?? map['weekDay'];

    return NotificationModel(
      id: value['id'],
      title: value['title'],
      body: value['body'],
      payload: value['payload'],
      dateTime: date,
      weekday: _weekDay,
    );
  }

  String get payloadText {
    Map map = json.decode(payload);
    return map['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'payload': payload,
      'dateTime': dateTime?.millisecondsSinceEpoch.toString(),
      'weekday': weekday,
    };
  }

  String toString() =>
      '{ id: $id, title: $title, body: $body, payload: $payload, dateTime: $dateTime }';
}
