import 'package:aluno_uepb/app/modules/home/about/about_app_page.dart';
import 'package:aluno_uepb/app/modules/home/history/history_controller.dart';
import 'package:aluno_uepb/app/modules/home/history/history_page.dart';
import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'profile_controller.dart';
import 'profile_page.dart';

class ProfileModule extends Module {
  static final TransitionType _secondaryTransition = TransitionType.downToUp;

  @override
  final List<Bind> binds = [
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
      child: (_, __) => ProfilePage(),
    ),
    ChildRoute(
      '/history',
      child: (_, __) => HistoryPage(),
      transition: _secondaryTransition,
    ),
    ChildRoute(
      '/about',
      child: (_, __) => AboutAppPage(),
      transition: _secondaryTransition,
    ),
  ];
}
