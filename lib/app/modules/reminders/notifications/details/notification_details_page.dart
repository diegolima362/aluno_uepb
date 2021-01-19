import 'package:aluno_uepb/app/shared/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationDetailsPage extends StatefulWidget {
  final String title = 'Notification Details';
  final NotificationModel notification;

  const NotificationDetailsPage({Key key, this.notification}) : super(key: key);

  @override
  _NotificationDetailsPageState createState() =>
      _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Text(widget.notification.payload),
    );
  }
}
