import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'tasks_details_controller.g.dart';

@Injectable()
class TaskDetailsController = _TaskDetailsControllerBase
    with _$TaskDetailsController;

abstract class _TaskDetailsControllerBase with Store {
  @observable
  bool done = false;

  @observable
  TaskModel task;

  final DataController storage;
  final INotificationsManager notificationsManager;

  _TaskDetailsControllerBase({
    required this.task,
    required this.storage,
    required this.notificationsManager,
  }) {
    done = task.isCompleted;
  }

  @action
  Future<void> delete() async {
    await storage.deleteTask(task.id);
  }

  @action
  Future<void> setDone(bool value) async {
    if (!task.isCompleted && value && task.hasReminder) {
      notificationsManager.cancelNotification(task.reminder!.id);
      task.reminder = null;
    }

    task.isCompleted = value;
    done = value;

    await storage.addTask(task);
  }
}
