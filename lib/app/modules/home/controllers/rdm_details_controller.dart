import 'dart:convert';

import 'package:aluno_uepb/app/modules/rdm/details/scheduler_page.dart';
import 'package:aluno_uepb/app/shared/event_logger/interfaces/event_logger_interface.dart';
import 'package:aluno_uepb/app/shared/models/course_model.dart';
import 'package:aluno_uepb/app/shared/models/notification_model.dart';
import 'package:aluno_uepb/app/shared/models/task_model.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'details_controller.g.dart';

@Injectable()
class DetailsController = _DetailsControllerBase with _$DetailsController;

abstract class _DetailsControllerBase with Store {
  final Map<int, String> weekDaysMap = {
    0: 'Dom',
    1: 'Seg',
    2: 'Ter',
    3: 'Qua',
    4: 'Qui',
    5: 'Sex',
    6: 'Sab',
  };

  @observable
  late CourseModel course;

  @observable
  ObservableList<NotificationModel> reminders =
      ObservableList<NotificationModel>();

  @observable
  ObservableList<TaskModel> tasks = ObservableList<TaskModel>();

  @observable
  bool isLoading = true;

  late final INotificationsManager _manager;

  late final DataController _storage;

  @observable
  String title = '';

  @observable
  bool extended = true;

  @observable
  ObservableList<bool> selectedDays = ObservableList<bool>()
    ..addAll(List.filled(7, false));

  @observable
  TimeOfDay dueTime = TimeOfDay(hour: 23, minute: 59);

  _DetailsControllerBase() {
    final CourseModel r = Modular.args!.data;

    _manager = Modular.get();
    _storage = Modular.get();

    setExtended(true);
    setCourse(r);
    loadData();
  }

  @computed
  bool get hasReminders => reminders.isNotEmpty;

  @computed
  bool get hasTasks => tasks.isNotEmpty;

  @action
  Future<void> deleteReminder(NotificationModel notification) async {
    await _manager.cancelNotification(notification.id);
    Modular.get<IEventLogger>().logEvent('logRemoveReminder');
    await loadData();
  }

  @action
  Future<void> loadData() async {
    isLoading = true;

    final List<List> data = await Future.wait([
      _manager.getAllNotifications(),
      _storage.getTasks(),
    ]);

    reminders.addAll(data[0]
        .cast<NotificationModel>()
        .where((x) => x.courseId == course.id && !x.taskReminder)
        .toList());

    tasks.addAll(data[1]
        .cast<TaskModel>()
        .where((x) => x.courseId == course.id)
        .toList());

    isLoading = false;
  }

  @action
  Future<void> scheduleReminder() async {
    final _title = title.isEmpty ? 'Sem Título' : title;

    for (int i = 0, l = selectedDays.length; i < l; i++) {
      if (selectedDays[i]) {
        final date = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          dueTime.hour,
          dueTime.minute,
        );
        final payload = {
          'title': _title,
          'date': date.millisecondsSinceEpoch.toString(),
          'text': course.name,
          'courseId': course.id,
          'courseName': course.name,
          'type': 'weekly',
          'weekDay': i == 0 ? 7 : i,
        };

        final notification = NotificationModel(
          id: (DateTime.now().millisecondsSinceEpoch ~/ 6000) + i,
          title: _title,
          body: course.name,
          payload: json.encode(payload),
          dateTime: date,
          weekday: i == 0 ? 7 : i,
        );

        await _manager.scheduleWeeklyNotification(notification);
        Modular.get<IEventLogger>().logEvent('logAddReminder');
        await loadData();
      }
    }
  }

  @action
  void setCourse(CourseModel value) {
    course = value;
  }

  @action
  void setDay(int day) {
    selectedDays[day] = !selectedDays[day];
  }

  @action
  void setDueTime(TimeOfDay value) => dueTime = value;

  @action
  void setExtended(bool value) {
    extended = value;
  }

  @action
  void setTitle(String value) => title = value;

  @action
  Future<void> showDetails(TaskModel task) async {
    await Modular.to.pushNamed('reminders/task/details', arguments: task);
    await loadData();
  }

  @action
  Future<void> showScheduler() async {
    await Modular.to.push(MaterialPageRoute(
      builder: (_) => SchedulerPage(),
    ));
  }
}
