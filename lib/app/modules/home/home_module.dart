import 'package:flutter_modular/flutter_modular.dart';

import 'controllers/controllers.dart';
import 'pages/pages.dart';

class HomeModule extends Module {
  static final TransitionType _primaryTransition = TransitionType.noTransition;
  static final TransitionType _secondaryTransition = TransitionType.downToUp;

  @override
  final List<Bind> binds = [
    Bind.singleton((i) => HomeController()),
    Bind.lazySingleton((i) => HomeContentController()),
    Bind.lazySingleton((i) => FullScheduleController()),
    Bind.lazySingleton((i) => RdmController()),
    Bind.lazySingleton((i) => RDMDetailsController()),
    Bind.lazySingleton((i) => SchedulerController()),
    Bind.lazySingleton((i) => RemindersController()),
    Bind.lazySingleton((i) => TaskDetailsController()),
    Bind.lazySingleton((i) => TasksEditController()),
    Bind.lazySingleton((i) => ProfileController()),
    Bind.lazySingleton((i) => HistoryController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (context, args) => HomePage(),
      children: [
        ChildRoute(
          '/content',
          child: (_, __) => HomeContentPage(),
          transition: _primaryTransition,
        ),
        ChildRoute(
          '/rdm',
          child: (_, __) => RdmPage(),
          transition: _primaryTransition,
        ),
        ChildRoute(
          '/reminders',
          child: (_, __) => RemindersPage(),
          transition: _primaryTransition,
        ),
        ChildRoute(
          '/profile',
          child: (_, __) => ProfilePage(),
          transition: _primaryTransition,
        ),
      ],
    ),
    ChildRoute(
      '/content/details',
      child: (_, __) => FullSchedulePage(),
      transition: _secondaryTransition,
    ),
    ChildRoute(
      '/rdm/details',
      child: (_, __) => RDMDetailsPage(),
      transition: _secondaryTransition,
    ),
    ChildRoute(
      '/rdm/details/scheduler',
      child: (_, __) => SchedulerPage(),
      transition: _secondaryTransition,
    ),
    ChildRoute(
      '/reminders/task/edit',
      child: (_, __) => TaskEditPage(),
      transition: _secondaryTransition,
    ),
    ChildRoute(
      '/reminders/task/details',
      child: (_, __) => TaskDetailsPage(),
      transition: _secondaryTransition,
    ),
    ChildRoute(
      '/profile/history',
      child: (_, __) => HistoryPage(),
      transition: _secondaryTransition,
    ),
    ChildRoute(
      '/profile/details',
      child: (_, __) => AboutAppPage(),
      transition: _secondaryTransition,
    ),
  ];
}
