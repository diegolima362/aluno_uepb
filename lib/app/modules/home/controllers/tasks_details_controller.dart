import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'controllers.dart';

part 'tasks_details_controller.g.dart';

@Injectable()
class TaskDetailsController = _TaskDetailsControllerBase
    with _$TaskDetailsController;

abstract class _TaskDetailsControllerBase with Store {
  @observable
  TaskModel task = Modular.args!.data;

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

    final RemindersController controller = Modular.get();
    await controller.loadData();

    Modular.to.pop();
  }

  @action
  void edit() {
    Modular.to.pushNamed('/home/reminders/task/edit', arguments: task);
  }

  @action
  Future<void> setDone(bool value) async {
    task.isCompleted = value;

    setTask(task);

    await _storage.addTask(task);

    await Modular.get<RemindersController>().loadData();

    done = value;
  }

  @action
  void setTask(TaskModel t) {
    task = t;
    done = t.isCompleted;
  }
}
