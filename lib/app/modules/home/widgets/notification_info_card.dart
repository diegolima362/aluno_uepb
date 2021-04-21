import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/utils/format.dart';
import 'package:flutter/material.dart';

class NotificationInfoCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onDelete;

  final Map<int, String> weekDaysMap = {
    0: 'Dom',
    1: 'Seg',
    2: 'Ter',
    3: 'Qua',
    4: 'Qui',
    5: 'Sex',
    6: 'Sab',
    7: 'Dom',
  };

  NotificationInfoCard({
    Key? key,
    required this.notification,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).accentColor;
    final now = DateTime.now();

    return GestureDetector(
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: accentColor,
                  ),
                ),
                subtitle: Text(
                  notification.payloadText,
                  style: TextStyle(fontSize: 14.0),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: accentColor),
                  onPressed: onDelete,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (notification.weekly)
                    Text(
                      weekDaysMap[notification.weekday] ?? '',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    )
                  else
                    Text(
                      Format.date(notification.dateTime ?? now),
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  Text(
                    Format.hours(notification.dateTime ?? now),
                    style: TextStyle(fontSize: 12.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
