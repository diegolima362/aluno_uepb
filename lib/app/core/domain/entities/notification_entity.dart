class NotificationEntity {
  final int id;
  final String title;
  final String payload;
  final String body;
  final DateTime dateTime;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    required this.dateTime,
  });
}
