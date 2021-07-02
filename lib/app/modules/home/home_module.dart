import 'package:aluno_uepb/app/modules/home/tasks/task_details/tasks_details_controller.dart';
import 'package:aluno_uepb/app/modules/home/tasks/task_edit/tasks_edit_controller.dart';
import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'about/about_app_page.dart';
import 'full_schedule/full_schedule_controller.dart';
import 'full_schedule/full_schedule_page.dart';
import 'history/history_controller.dart';
import 'history/history_page.dart';
import 'home_controller.dart';
import 'home_page.dart';
import 'profile/profile_controller.dart';
import 'profile/profile_page.dart';
import 'rdm/details/rdm_details_controller.dart';
import 'rdm/details/rdm_details_page.dart';
import 'rdm/rdm_controller.dart';
import 'rdm/rdm_page.dart';
import 'rdm/scheduler/scheduler_controller.dart';
import 'rdm/scheduler/scheduler_page.dart';
import 'routes.dart' as home;
import 'tasks/task_details/tasks_details_page.dart';
import 'tasks/task_edit/tasks_edit_page.dart';
import 'tasks/tasks_controller.dart';
import 'tasks/tasks_page.dart';
import 'today_schedule/today_schedule_controller.dart';
import 'today_schedule/today_schedule_page.dart';

class HomeModule extends Module {
  static final TransitionType _primaryTransition = TransitionType.noTransition;
  static final TransitionType _secondaryTransition = TransitionType.downToUp;

  @override
  final List<Bind> binds = [
    Bind.singleton((i) => HomeController(i.get<DataController>())),
    Bind.lazySingleton((i) => TodayScheduleController(i.get<DataController>())),
    Bind.lazySingleton((i) => FullScheduleController(i.get<DataController>())),
    Bind.lazySingleton((i) => RdmController(i.get<DataController>())),
    Bind.lazySingleton((i) => HistoryController(i.get<DataController>())),
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
        ChildRoute(
          '/' + home.TODAY_SCHEDULE_PAGE,
          child: (_, __) => TodaySchedulePage(),
          transition: _primaryTransition,
        ),
        ChildRoute(
          '/' + home.FULL_SCHEDULE_PAGE,
          child: (_, __) => FullSchedulePage(),
          transition: _secondaryTransition,
        ),
        ChildRoute(
          '/' + home.RDM_PAGE,
          child: (_, __) => RdmPage(),
          transition: _primaryTransition,
        ),
        ChildRoute(
          '/' + home.COURSE_DETAILS,
          child: (_, __) => RDMDetailsPage(),
          transition: _secondaryTransition,
        ),
        ChildRoute(
          '/' + home.COURSE_SCHEDULER,
          child: (_, __) => SchedulerPage(),
          transition: _secondaryTransition,
        ),
        ChildRoute(
          '/' + home.TASKS_PAGE,
          child: (_, __) => TasksPage(),
          transition: _primaryTransition,
        ),
        ChildRoute(
          '/' + home.TASKS_EDIT,
          child: (_, __) => TaskEditPage(),
          transition: _secondaryTransition,
        ),
        ChildRoute(
          '/' + home.TASKS_DETAILS,
          child: (_, __) => TaskDetailsPage(),
          transition: _secondaryTransition,
        ),
        ChildRoute(
          '/' + home.PROFILE_PAGE,
          child: (_, __) => ProfilePage(),
          transition: _primaryTransition,
        ),
        ChildRoute(
          '/' + home.HISTORY_PAGE,
          child: (_, __) => HistoryPage(),
          transition: _secondaryTransition,
        ),
        ChildRoute(
          '/' + home.ABOUT_PAGE,
          child: (_, __) => AboutAppPage(),
          transition: _secondaryTransition,
        ),
      ],
    ),
  ];
}
