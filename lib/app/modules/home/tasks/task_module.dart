import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'task_details/tasks_details_controller.dart';
import 'task_details/tasks_details_page.dart';
import 'task_edit/tasks_edit_controller.dart';
import 'task_edit/tasks_edit_page.dart';
import 'tasks_controller.dart';
import 'tasks_page.dart';

class TaskModule extends Module {
  static final TransitionType _secondaryTransition = TransitionType.downToUp;

  @override
  final List<Bind> binds = [
    Bind.lazySingleton(
      (i) => TasksController(
        i.get<DataController>(),
        i.get<INotificationsManager>(),
      ),
    ),
    Bind.lazySingleton(
      (i) => TasksEditController(
        storage: i.get<DataController>(),
        notificationsManager: i.get<INotificationsManager>(),
        task: i.args!.data,
      ),
    ),
    Bind.lazySingleton(
      (i) => TaskDetailsController(
        storage: i.get<DataController>(),
        task: i.args!.data,
        notificationsManager: i.get<INotificationsManager>(),
      ),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (context, args) => TasksPage(),
    ),
    ChildRoute(
      '/edit',
      child: (_, __) => TaskEditPage(),
      transition: _secondaryTransition,
    ),
    ChildRoute(
      '/details',
      child: (_, __) => TaskDetailsPage(),
      transition: _secondaryTransition,
    ),
  ];
}
