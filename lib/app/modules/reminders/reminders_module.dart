import 'package:aluno_uepb/app/modules/reminders/tasks/details/details_controller.dart';
import 'package:aluno_uepb/app/modules/reminders/tasks/edit/edit_controller.dart';
import 'package:aluno_uepb/app/modules/reminders/tasks/edit/edit_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'notifications/details/notification_details_page.dart';
import 'reminders_controller.dart';
import 'reminders_page.dart';
import 'tasks/details/details_page.dart';

class RemindersModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => RemindersController()),
    Bind.lazySingleton((i) => EditController()),
    Bind.lazySingleton((i) => TaskDetailsController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => RemindersPage()),
    ChildRoute('notifications/details',
        child: (_, args) => NotificationDetailsPage()),
    ChildRoute('task/details', child: (_, args) => TaskDetailsPage()),
    ChildRoute('task/edit', child: (_, args) => TaskEditPage()),
  ];
}
