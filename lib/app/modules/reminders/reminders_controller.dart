import 'package:aluno_uepb/app/shared/models/course_model.dart';
import 'package:aluno_uepb/app/shared/models/task_model.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'sort_by.dart';

part 'reminders_controller.g.dart';

@Injectable()
class RemindersController = _RemindersControllerBase with _$RemindersController;

abstract class _RemindersControllerBase with Store {
  DataController _storage;

  @observable
  ObservableList<TaskModel> tasks;

  @observable
  ObservableList<TaskModel> completedTasks;

  @observable
  ObservableList<TaskModel> deleteList;

  @observable
  ObservableList<CourseModel> courses;

  @observable
  bool isLoading;

  @observable
  bool extended;

  @observable
  bool deleteMode;

  INotificationsManager _manager;

  _RemindersControllerBase() {
    _storage = Modular.get();
    _manager = Modular.get();

    extended = true;
    deleteMode = false;
    loadData();
  }

  @computed
  bool get hasCompletedTasks =>
      completedTasks != null && completedTasks.isNotEmpty;

  @computed
  bool get hasCourses => courses?.isNotEmpty ?? false;

  @computed
  bool get hasTasks => tasks != null && tasks.isNotEmpty;

  @computed
  bool get hasTasksToDelete => deleteList != null && deleteList.isNotEmpty;

  @action
  Future<void> addTask() async {
    await Modular.to.pushNamed('reminders/task/edit', arguments: null);
  }

  @action
  void addToDelete(TaskModel task) {
    if (deleteList == null) deleteList = ObservableList<TaskModel>();
    deleteList.add(task);
  }

  @action
  Future<void> delete(TaskModel task) async {
    await _storage.deleteTask(task.id);

    if (task.reminder != null) {
      await _manager.cancelNotification(task.reminder.id);
    }

    await loadData();
  }

  @action
  Future<void> deleteItems() async {
    deleteList.forEach((t) async => await delete(t));
    deleteList.clear();
    setDeleteMode();
  }

  @action
  Future<void> edit(TaskModel task) async {
    await Modular.to.pushNamed('reminders/task/edit', arguments: task);
  }

  @action
  Future<void> loadData() async {
    isLoading = true;

    setCourses(await _storage.getCourses());
    setTasks(await _storage.getTasks());

    isLoading = false;
  }

  @action
  Future<void> markAsDone(TaskModel task) async {
    task.isCompleted = !task.isCompleted;

    if (!task.isCompleted && task.hasReminder && task.isAfterNow) {
      await _manager.scheduleNotification(task.reminder);
    } else if (task.hasReminder && (task.isCompleted || task.isBeforeNow)) {
      await _manager.cancelNotification(task.reminder.id);
    }

    await _storage.addTask(task);
    await loadData();
  }

  @action
  void removeFromDeleteList(TaskModel task) {
    deleteList.remove(task);
  }

  @action
  void setCourses(List<CourseModel> value) {
    if (value != null) {
      courses = ObservableList<CourseModel>();
      courses.addAll(value);
      courses.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    }
  }

  @action
  void setDeleteMode() {
    deleteMode = !deleteMode;

    if (!deleteMode && hasTasksToDelete) deleteList.clear();
  }

  @action
  void setExtended(bool value) {
    extended = value;
  }

  @action
  void setTasks(List<TaskModel> value) {
    if (value != null) {
      tasks = ObservableList<TaskModel>();
      tasks.addAll(
        value.where((t) => !t.isCompleted && t.isAfterNow),
      );

      completedTasks = ObservableList<TaskModel>();
      completedTasks.addAll(
        value.where((t) => t.isCompleted || t.isBeforeNow),
      );

      tasks.sort(
        (a, b) => a.dueDate.compareTo(b.dueDate),
      );

      completedTasks.sort(
        (a, b) => a.dueDate.compareTo(b.dueDate),
      );
    }
  }

  @action
  Future<void> showDetails(TaskModel task) async {
    await Modular.to.pushNamed('reminders/task/details', arguments: task);
  }

  @action
  void sortBy(SortBy value) {
    if (tasks == null ||
        tasks.isEmpty && completedTasks == null ||
        completedTasks.isEmpty) return;

    if (value == SortBy.COURSE) {
      tasks.sort((a, b) =>
          a.courseTitle.toLowerCase().compareTo(b.courseTitle.toLowerCase()));
      completedTasks.sort((a, b) =>
          a.courseTitle.toLowerCase().compareTo(b.courseTitle.toLowerCase()));
    } else if (value == SortBy.DATE) {
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      completedTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (value == SortBy.TITLE) {
      tasks.sort((a, b) => a.title.compareTo(b.title));
      completedTasks.sort((a, b) => a.title.compareTo(b.title));
    }
  }
}
