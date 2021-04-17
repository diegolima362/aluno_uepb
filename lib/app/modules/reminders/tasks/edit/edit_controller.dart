import 'dart:convert';

import 'package:aluno_uepb/app/modules/reminders/tasks/details/details_controller.dart';
import 'package:aluno_uepb/app/shared/event_logger/interfaces/event_logger_interface.dart';
import 'package:aluno_uepb/app/shared/models/course_model.dart';
import 'package:aluno_uepb/app/shared/models/notification_model.dart';
import 'package:aluno_uepb/app/shared/models/task_model.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../reminders_controller.dart';

part 'edit_controller.g.dart';

@Injectable()
class EditController = _EditControllerBase with _$EditController;

abstract class _EditControllerBase with Store {
  @observable
  bool isLoading;

  @observable
  DateTime dueDate;

  @observable
  TimeOfDay dueTime;

  @observable
  bool isCompleted;

  @observable
  bool undone;

  @observable
  bool reminder;

  @observable
  String title;

  @observable
  String text;

  @observable
  TaskModel task;

  INotificationsManager _manager;

  @observable
  CourseModel course;

  @observable
  ObservableList<CourseModel> courses;

  DataController _storage;

  _EditControllerBase() {
    final TaskModel task = Modular.args.data;
    _manager = Modular.get();
    _storage = Modular.get();

    setTask(task);
    setUndone(false);

    loadData();
  }

  @action
  Future<void> loadData() async {
    isLoading = true;
    courses = ObservableList<CourseModel>();

    final data = await _storage.getCourses();

    if (data.isEmpty) isLoading = false;

    courses.addAll(data);
    courses.sort((a, b) => a.name.compareTo(b.name));

    if (task?.courseId != null) {
      final l = courses.where((r) => r.id == task.courseId).toList();
      if (l.length > 0) {
        setCourse(l[0]);
      } else {
        setCourse(courses[0]);
      }
    } else {
      setCourse(courses[0]);
    }

    setReminder(await _checkActiveNotification());

    isLoading = false;
  }

  @action
  Future<void> save() async {
    final t = _taskFromState();
    final _active = task?.setReminder ?? false;
    final _hasReminder = task?.reminder != null;

    if (_active && !t.setReminder && _hasReminder) {
      await _manager.cancelNotification(task.reminder.id);
      Modular.get<IEventLogger>().logEvent('logDeleteTaskReminder');
    }

    if (t.setReminder && !t.dueDate.isBefore(DateTime.now())) {
      final date = t.dueDate.millisecondsSinceEpoch.toString();
      final payload = {
        'title': t.title,
        'date': date,
        'text': course.name,
        'courseId': course.id,
        'courseName': course.name,
        'type': 'task'
      };

      NotificationModel notification = NotificationModel(
        id: _idFromDate(),
        title: t.title,
        body: t.courseTitle,
        payload: json.encode(payload),
        dateTime: t.dueDate,
        weekday: t.dueDate.weekday,
      );

      t.reminder = notification;

      await _manager.scheduleNotification(notification);
      Modular.get<IEventLogger>().logEvent('logAddTaskReminder');
    }

    await _storage.addTask(t);

    Modular.get<IEventLogger>().logEvent('logAddTask');

    if (task != null) {
      Modular.get<TaskDetailsController>().setTask(t);
    }

    await Modular.get<RemindersController>().loadData();

    Modular.to.pop();
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
  void setReminder(bool value) => reminder = value;

  @action
  void setTask(TaskModel value) {
    task = value;

    if (task != null) {
      setText(task.text);
      setTitle(task.title);
      setDueDate(task.dueDate);
      setDueTime(TimeOfDay.fromDateTime(task.dueDate));
      setIsCompleted(task.isCompleted);
      setReminder(task.setReminder);
    } else {
      final date = DateTime.now();

      setDueDate(date);
      setDueTime(TimeOfDay.fromDateTime(date));
      setText('');
      setTitle('Atividade');
      setIsCompleted(false);
      setReminder(false);
    }
  }

  @action
  void setText(String value) => text = value;

  @action
  void setTitle(String value) => title = value;

  @action
  void setUndone(bool value) => undone = value;

  Future<bool> _checkActiveNotification() async {
    if (task?.setReminder ?? false) {
      final data = await _manager.getAllNotifications();
      for (NotificationModel n in data)
        if (n.id == task.reminder.id) return true;
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
      title: title == null || title.isEmpty ? 'Sem título' : title,
      courseId: course.id,
      courseTitle: course.name,
      createdDate: _createdDate,
      dueDate: _dueDate,
      text: text,
      isCompleted: _completed,
      setReminder: reminder,
    );
  }
}
