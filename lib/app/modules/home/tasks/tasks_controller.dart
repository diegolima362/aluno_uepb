import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'tasks_controller.g.dart';

enum SortBy {
  COURSE,
  DATE,
  TITLE,
}

@Injectable()
class TasksController = _TasksControllerBase with _$TasksController;

abstract class _TasksControllerBase with Store {
  @observable
  var tasks = ObservableList<TaskModel>();

  @observable
  var completedTasks = ObservableList<TaskModel>();

  @observable
  var deleteList = ObservableList<TaskModel>();

  @observable
  bool isLoading = true;

  @observable
  bool hasError = false;

  @observable
  bool deleteMode = false;

  @observable
  bool hasCourses = false;

  final DataController storage;
  final INotificationsManager manager;

  _TasksControllerBase(this.storage, this.manager) {
    loadData();
  }

  @computed
  bool get hasCompletedTasks => completedTasks.isNotEmpty;

  @computed
  bool get hasTasks => tasks.isNotEmpty;

  @computed
  bool get hasTasksToDelete => deleteList.isNotEmpty;

  @action
  void addToDelete(TaskModel task) {
    deleteList.add(task);
  }

  @action
  Future<void> delete(TaskModel task) async {
    await storage.deleteTask(task.id);

    if (task.reminder != null) {
      await manager.cancelNotification(task.reminder!.id);
    }

    await loadData();
  }

  @action
  Future<void> deleteItems() async {
    deleteList.forEach((t) async => await delete(t));
    deleteList.clear();
    toggleDeleteMode();
  }

  @action
  Future<void> loadData() async {
    try {
      isLoading = true;

      hasCourses = ((await storage.getCourses())?.length ?? 0) > 0;
      final result = await storage.getTasks();

      result.forEach((t) {
        if (t.reminder != null) {
          if (t.dueDate.isBefore(DateTime.now())) {
            manager.cancelNotification(t.reminder!.id);
            t.reminder = null;
          }
        }
      });

      setTasks(result);

      isLoading = false;
    } catch (e) {
      print('TasksController > \n$e');
      isLoading = false;
      hasError = true;
    }
  }

  @action
  void removeFromDeleteList(TaskModel task) {
    deleteList.remove(task);
  }

  @action
  void toggleDeleteMode() {
    deleteMode = !deleteMode;
    if (!deleteMode && hasTasksToDelete) deleteList.clear();
  }

  @action
  void setTasks(List<TaskModel>? value) {
    if (value != null) {
      tasks.clear();
      tasks.addAll(
        value.where((t) => !t.isCompleted && t.isAfterNow),
      );

      completedTasks.clear();
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
  void sortTasks(SortBy value) {
    if (tasks.isEmpty && completedTasks.isEmpty) return;

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
