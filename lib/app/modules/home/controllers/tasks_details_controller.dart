import 'package:aluno_uepb/app/modules/reminders/reminders_controller.dart';
import 'package:aluno_uepb/app/shared/event_logger/interfaces/event_logger_interface.dart';
import 'package:aluno_uepb/app/shared/models/task_model.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'details_controller.g.dart';

@Injectable()
class TaskDetailsController = _TaskDetailsControllerBase
    with _$TaskDetailsController;

abstract class _TaskDetailsControllerBase with Store {
  @observable
  late TaskModel task;

  @observable
  bool done = false;

  late final DataController _storage;

  _TaskDetailsControllerBase() {
    _storage = Modular.get();

    final TaskModel t = Modular.args!.data;
    setTask(t);
    done = t.isCompleted;
  }

  @action
  Future<void> delete() async {
    await _storage.deleteTask(task.id);

    Modular.get<IEventLogger>().logEvent('logRemoveTask');

    final RemindersController controller = Modular.get();
    await controller.loadData();

    Modular.to.pop();
  }

  @action
  void edit() {
    Modular.to.pushNamed('/task/edit', arguments: task);
    Modular.get<IEventLogger>().logEvent('logEditTask');
  }

  @action
  Future<void> setDone(bool value) async {
    task.isCompleted = value;

    setTask(task);

    await _storage.addTask(task);

    await Modular.get<RemindersController>().loadData();

    Modular.get<IEventLogger>().logEvent('logMarkTaskCompleted');

    done = value;
  }

  @action
  void setTask(TaskModel t) {
    task = t;
    done = t.isCompleted;
  }
}
