import 'package:aluno_uepb/app/modules/home/schedule/schedule_module.dart';
import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'history/history_controller.dart';
import 'home_controller.dart';
import 'home_page.dart';
import 'profile/pofile_module.dart';
import 'profile/profile_controller.dart';
import 'rdm/rdm_module.dart';
import 'tasks/task_module.dart';

class HomeModule extends Module {
  static final TransitionType _primaryTransition = TransitionType.noTransition;

  @override
  final List<Bind> binds = [
    Bind.singleton((i) => HomeController(i.get<DataController>())),
    Bind.lazySingleton((i) => HistoryController(i.get<DataController>())),
    Bind.lazySingleton(
      (i) => ProfileController(
        authController: i.get<AuthController>(),
        notificationManager: i.get<INotificationsManager>(),
        storage: i.get<DataController>(),
      ),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (context, args) => HomePage(),
      children: [
        ModuleRoute(
          'schedule',
          module: ScheduleModule(),
          transition: _primaryTransition,
        ),
        ModuleRoute(
          'rdm',
          module: RdmModule(),
          transition: _primaryTransition,
        ),
        ModuleRoute(
          'tasks',
          module: TaskModule(),
          transition: _primaryTransition,
        ),
        ModuleRoute(
          'profile',
          module: ProfileModule(),
          transition: _primaryTransition,
        ),
      ],
    ),
  ];
}
