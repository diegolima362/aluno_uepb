import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'details/rdm_details_controller.dart';
import 'details/rdm_details_page.dart';
import 'rdm_controller.dart';
import 'rdm_page.dart';
import 'scheduler/scheduler_controller.dart';
import 'scheduler/scheduler_page.dart';

class RdmModule extends Module {
  static final TransitionType _secondaryTransition = TransitionType.downToUp;

  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => RdmController(i.get<DataController>())),
    Bind.lazySingleton(
      (i) => RDMDetailsController(
        course: i.args!.data,
        notificationManager: i.get<INotificationsManager>(),
        storage: i.get<DataController>(),
      ),
    ),
    Bind.lazySingleton(
      (i) => SchedulerController(
        course: i.args!.data,
        manager: i.get<INotificationsManager>(),
      ),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => RdmPage(),
    ),
    ChildRoute(
      '/details',
      child: (_, __) => RDMDetailsPage(),
      transition: _secondaryTransition,
    ),
    ChildRoute(
      '/schedule',
      child: (_, __) => SchedulerPage(),
      transition: _secondaryTransition,
    ),
  ];
}
