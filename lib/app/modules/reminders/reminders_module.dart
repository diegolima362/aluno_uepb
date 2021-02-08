import 'package:aluno_uepb/app/modules/reminders/tasks/details/details_controller.dart';
import 'package:aluno_uepb/app/modules/reminders/tasks/edit/edit_controller.dart';
import 'package:aluno_uepb/app/modules/reminders/tasks/edit/edit_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'notifications/details/notification_details_page.dart';
import 'reminders_controller.dart';
import 'reminders_page.dart';
import 'tasks/details/details_page.dart';

class RemindersModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        BindInject(
          (i) => RemindersController(),
          singleton: true,
          lazy: true,
        ),
        BindInject(
          (i) => EditController(),
          singleton: true,
          lazy: true,
        ),
        BindInject(
          (i) => TaskDetailsController(),
          singleton: true,
          lazy: true,
        ),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => RemindersPage()),
        ModularRouter('notifications/details',
            child: (_, args) => NotificationDetailsPage()),
        ModularRouter('task/details', child: (_, args) => TaskDetailsPage()),
        ModularRouter('task/edit', child: (_, args) => TaskEditPage()),
      ];

  static Inject get to => Inject<RemindersModule>.of();

  Widget get view => RemindersPage();
}
