import 'package:aluno_uepb/models/models.dart';
import 'package:aluno_uepb/services/notification_services.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:aluno_uepb/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CourseActiveReminders extends StatefulWidget {
  final NotificationsService notificationsService;
  final Course course;

  const CourseActiveReminders({
    Key key,
    @required this.notificationsService,
    @required this.course,
  }) : super(key: key);

  @override
  _CourseActiveRemindersState createState() => _CourseActiveRemindersState();
}

class _CourseActiveRemindersState extends State<CourseActiveReminders> {
  NotificationsService _notificationsService;
  Course _course;

  @override
  void initState() {
    super.initState();
    _course = widget.course;
    _notificationsService = widget.notificationsService;
  }

  Future<List<PendingNotificationRequest>> _getRemindersData() async {
    final notifications = await _notificationsService.getAllNotifications();

    return notifications.where((r) => r.body == _course.title).toList();
  }

  Future<void> _deleteReminder(int id) async {
    await _notificationsService.cancelNotification(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NotificationModel>(
      stream: _notificationsService.getNotificationsStream(),
      builder: (context, snapshot) {
        return FutureBuilder<List<PendingNotificationRequest>>(
          future: _getRemindersData(),
          builder: (context, snapshot) => ListItemsBuilder(
            emptyWidget: Text('Sem alertas agendados'),
            snapshot: snapshot,
            itemBuilder: (context, PendingNotificationRequest reminder) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  reminder.title,
                  style: TextStyle(
                    color: CustomThemes.accentColor,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(reminder.payload),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: CustomThemes.accentColor),
                  onPressed: () async => await _deleteReminder(reminder.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
