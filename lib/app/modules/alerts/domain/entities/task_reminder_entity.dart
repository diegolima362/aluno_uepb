class TaskReminderEntity {
  final int id;
  final String course;

  final String title;
  final String subject;
  final String body;

  final DateTime time;
  final bool notify;
  final bool completed;

  TaskReminderEntity({
    required this.id,
    required this.course,
    required this.title,
    required this.subject,
    required this.body,
    required this.time,
    required this.notify,
    required this.completed,
  });
}
