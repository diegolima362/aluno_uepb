import 'notification_model.dart';

class TaskModel {
  final String id;
  final String courseId;
  final String courseTitle;

  String title;
  DateTime dueDate;
  bool isCompleted;
  bool setReminder;
  String text;
  NotificationModel? reminder;

  DateTime createdDate = DateTime.now();

  TaskModel({
    required this.title,
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.dueDate,
    required this.createdDate,
    this.isCompleted = false,
    this.text = '',
    this.setReminder = false,
    this.reminder,
  });

  factory TaskModel.fromMap(Map<dynamic, dynamic> value) {
    final int now = DateTime.now().millisecondsSinceEpoch;

    final int due = int.tryParse(value['dueDate']) ?? now;
    final int created = int.tryParse(value['createdDate']) ?? now;

    NotificationModel? reminder = value['reminder'] != null
        ? NotificationModel.fromMap(value['reminder'])
        : null;

    return TaskModel(
      id: value['id'],
      title: value['title'] ?? '',
      courseId: value['courseId'],
      courseTitle: value['courseTitle'] ?? '',
      text: value['text'],
      isCompleted: value['isCompleted'] ?? false,
      setReminder: value['setReminder'] ?? false,
      reminder: reminder,
      dueDate: DateTime.fromMillisecondsSinceEpoch(due),
      createdDate: DateTime.fromMillisecondsSinceEpoch(created),
    );
  }

  bool get hasReminder => reminder != null;

  bool get isAfterNow => dueDate.isAfter(DateTime.now());

  bool get isBeforeNow => dueDate.isBefore(DateTime.now());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'text': text,
      'isCompleted': isCompleted,
      'setReminder': setReminder,
      'dueDate': dueDate.millisecondsSinceEpoch.toString(),
      'createdDate': createdDate.millisecondsSinceEpoch.toString(),
      'reminder': reminder?.toMap(),
    };
  }

  @override
  String toString() {
    return 'id: $id courseId: $courseId dueDate: $dueDate text: $text';
  }
}
