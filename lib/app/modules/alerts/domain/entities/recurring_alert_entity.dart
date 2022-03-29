import 'package:flutter/material.dart';

class RecurringAlertEntity {
  final int id;
  final String course;
  final List<int> days;
  final String title;
  final TimeOfDay time;

  RecurringAlertEntity({
    required this.id,
    required this.course,
    required this.days,
    required this.title,
    required this.time,
  });
}
