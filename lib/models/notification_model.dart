import 'package:flutter/foundation.dart';

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String payload;
  final DateTime dateTime;
  final int weekDay;

  NotificationModel({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
    this.weekDay,
    this.dateTime,
  });
}
