import 'dart:convert';

import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'scheduler_controller.g.dart';

@Injectable()
class SchedulerController = _SchedulerControllerBase with _$SchedulerController;

abstract class _SchedulerControllerBase with Store {
  final Map<int, String> weekDaysMap = {
    0: 'Dom',
    1: 'Seg',
    2: 'Ter',
    3: 'Qua',
    4: 'Qui',
    5: 'Sex',
    6: 'Sab',
  };

  final CourseModel course;

  late final INotificationsManager manager;

  @observable
  String title = '';

  @observable
  bool extended = true;

  @observable
  var selectedDays = ObservableList<bool>()..addAll(List.filled(7, false));

  @observable
  TimeOfDay dueTime = TimeOfDay(hour: 23, minute: 59);

  _SchedulerControllerBase({required this.course, required this.manager}) {
    // loadData();
  }

  @action
  Future<void> scheduleReminder() async {
    // (await manager.getAllNotifications())
    //     .where((x) => x.courseId == course.id && !x.taskReminder)
    //     .toList()
    //     .forEach((e) async => await manager.cancelNotification(e.id));

    final _title = title.isEmpty ? 'Sem Título' : title;

    for (int i = 0, l = selectedDays.length; i < l; i++) {
      final now = DateTime.now();
      if (selectedDays[i]) {
        final date = DateTime(
          now.year,
          now.month,
          now.day,
          dueTime.hour,
          dueTime.minute,
        );
        final payload = {
          'title': course.name + ': ' + _title,
          'date': date.millisecondsSinceEpoch.toString(),
          'text': course.name,
          'courseId': course.id,
          'courseName': course.name,
          'type': 'weekly',
          'weekDay': i == 0 ? 7 : i,
        };

        final notification = NotificationModel(
          id: (now.millisecondsSinceEpoch ~/ 6000) + i,
          title: _title,
          body: course.name,
          payload: json.encode(payload),
          dateTime: date,
          weekday: i == 0 ? 7 : i,
        );

        await manager.scheduleWeeklyNotification(notification);
      }
    }
  }

  @action
  Future<void> loadData() async {
    (await manager.getAllNotifications())
        .where((x) => x.courseId == course.id && !x.taskReminder)
        .toList()
        .forEach((e) => selectedDays[e.weekday! == 7 ? 0 : e.weekday!] = true);
  }

  @action
  void setDay(int day) {
    selectedDays[day] = !selectedDays[day];
  }

  @action
  void setDueTime(TimeOfDay value) => dueTime = value;

  @action
  void setTitle(String value) => title = value;
}
