import 'dart:convert';

import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'tasks_edit_controller.g.dart';

@Injectable()
class TasksEditController = _EditControllerBase with _$TasksEditController;

abstract class _EditControllerBase with Store {
  @observable
  bool isLoading = true;

  @observable
  bool hasError = false;

  @observable
  DateTime dueDate = DateTime.now();

  @observable
  TimeOfDay dueTime = TimeOfDay(hour: 23, minute: 59);

  @observable
  bool isCompleted = false;

  @observable
  bool undone = false;

  @observable
  bool reminder = false;

  @observable
  String title = '';

  @observable
  String text = '';

  @observable
  TaskModel? task;

  @observable
  CourseModel? course;

  @observable
  var courses = ObservableList<CourseModel>();

  late final INotificationsManager notificationsManager;

  late final DataController storage;

  late final bool isNew;

  _EditControllerBase({
    required this.storage,
    required this.notificationsManager,
    TaskModel? task,
  }) {
    isNew = task == null;
    setTask(task);
  }

  @action
  Future<void> loadData() async {
    isLoading = true;
    try {
      final result = await storage.getCourses();
      courses.clear();
      courses.addAll(result!);
      courses.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      print('TasksEditController > \n$e');
      hasError = true;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> save() async {
    final t = _taskFromState();

    if (task != null && task!.reminder != null)
      await notificationsManager.cancelNotification(task!.reminder!.id);

    if (t.setReminder && !t.dueDate.isBefore(DateTime.now())) {
      final payload = t.toMap();

      payload['type'] = 'task';

      NotificationModel notification = NotificationModel(
        id: _idFromDate(),
        title: t.title,
        body: t.courseTitle,
        payload: json.encode(payload),
        dateTime: t.dueDate,
        weekday: t.dueDate.weekday,
      );

      t.reminder = notification;

      await notificationsManager.scheduleNotification(notification);
    }

    await storage.addTask(t);
  }

  @action
  void setCourse(CourseModel value) => course = value;

  @action
  void setDueDate(DateTime value) => dueDate = value;

  @action
  void setDueTime(TimeOfDay value) => dueTime = value;

  @action
  void setIsCompleted(bool value) {
    isCompleted = value;
    setUndone(isCompleted);
  }

  @action
  void setReminder(bool? value) => reminder = value ?? false;

  @action
  Future<void> setTask(TaskModel? value) async {
    await loadData();
    if (value != null) {
      task = value;
      setText(value.text);
      setTitle(value.title);
      setDueDate(value.dueDate);
      setDueTime(TimeOfDay.fromDateTime(value.dueDate));
      setIsCompleted(value.isCompleted);

      setReminder(await _checkActiveNotification());

      final c = courses.firstWhere(
        (r) => r.id == (task?.courseId ?? courses[0].id),
      );

      setCourse(c);
    } else {
      final date = DateTime.now();
      setCourse(courses[0]);
      setDueDate(date);
      setDueTime(TimeOfDay.fromDateTime(date));
      setText('');
      setTitle('Atividade');
      setIsCompleted(false);
      setReminder(false);

      task = TaskModel(
        id: _idFromDate().toString(),
        title: '',
        dueDate: date,
        courseId: '',
        courseTitle: course?.name ?? '',
        createdDate: date,
      );
    }
  }

  @action
  void setText(String value) => text = value;

  @action
  void setTitle(String value) => title = value;

  @action
  void setUndone(bool? value) => undone = value ?? false;

  Future<bool> _checkActiveNotification() async {
    if (task?.setReminder ?? false) {
      final data = await notificationsManager.getAllNotifications();

      for (NotificationModel n in data)
        if (n.id == (task?.reminder?.id ?? -1)) return true;
    }
    return false;
  }

  int _idFromDate() => DateTime.now().millisecondsSinceEpoch ~/ 6000;

  TaskModel _taskFromState() {
    final _createdDate = DateTime.now();
    final _id = task?.id ?? _idFromDate().toString();

    final _dueDate = DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
      dueTime.hour,
      dueTime.minute,
    );

    final _completed = isCompleted ? !undone : isCompleted;

    return TaskModel(
      id: _id,
      title: title.isEmpty ? 'Sem título' : title,
      courseId: course!.id,
      courseTitle: course!.name,
      createdDate: _createdDate,
      dueDate: _dueDate,
      text: text,
      isCompleted: _completed,
      setReminder: reminder,
    );
  }
}
