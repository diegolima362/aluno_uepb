import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'app_widget.dart';
import 'core/external/drivers/drivers.dart';
import 'core/infra/services/services.dart';
import 'core/presenter/pages/landing/landing_page.dart';
import 'core/presenter/stores/auth_store.dart';
import 'core/presenter/stores/preferences_store.dart';
import 'core/presenter/widgets/responsive.dart';
import 'modules/alerts/alerts_module.dart';
import 'modules/auth/auth_module.dart';
import 'modules/courses/courses_module.dart';
import 'modules/history/history_module.dart';
import 'modules/preferences/preferences_module.dart';
import 'modules/profile/profile_module.dart';
import 'modules/root/root_page.dart';

class AppModule extends Module {
  final SharedPreferences prefs;

  AppModule({required this.prefs});

  @override
  List<Bind> get binds => [
        Bind.lazySingleton((i) => SharedPrefs(prefs)),

        Bind.singleton(
          (i) => AppDriftDatabase.connect(
            createDriftIsolateAndConnect(),
          ),
        ),

        // auth
        ...AuthModule.export,

        // courses
        ...CoursesModule.export,

        // reminders
        ...AlertsModule.export,

        // preferences
        ...PreferencesModule.export,

        // profile
        ...ProfileModule.export,

        // profile
        ...HistoryModule.export,

        // core stores
        Bind.lazySingleton((i) => AuthStore(i(), i())),
        Bind.lazySingleton(
            (i) => PreferencesStore(i(), i(), i(), i(), i(), i())),

        // services
        Bind.lazySingleton((i) => ConnectivityService(i())),
        Bind.lazySingleton((i) => NotificationsService(i())),
        Bind.lazySingleton((i) => WorkManagerService(i())),

        // tools
        Bind.lazySingleton((i) => Client()),
        Bind.lazySingleton((i) => Session(i())),

        // External plugins
        Bind.lazySingleton((i) => Connectivity()),
        Bind.lazySingleton((i) => FlutterLocalNotificationsPlugin()),
        Bind.lazySingleton((i) => Workmanager()),

        // Drivers
        Bind.lazySingleton((i) => ConnectivityDriver(i())),
        Bind.lazySingleton((i) => NotificationsDriver(i())),
        Bind.lazySingleton((i) => WorkManagerDriver(i())),

        Bind.lazySingleton((i) => ResponsiveSize(globalContext)),
      ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      Modular.initialRoute,
      child: (context, args) => LandingPage(),
    ),
    ChildRoute(
      '/root/',
      child: (context, args) => const RootPage(),
      children: [
        ModuleRoute(
          '/courses/',
          module: CoursesModule(),
          duration: Duration.zero,
        ),
        ModuleRoute(
          '/alerts/',
          module: AlertsModule(),
          duration: Duration.zero,
        ),
        ModuleRoute(
          '/preferences/',
          module: PreferencesModule(),
          transition: TransitionType.rightToLeft,
        ),
        ModuleRoute(
          '/profile/',
          module: ProfileModule(),
          transition: TransitionType.rightToLeft,
        ),
        ModuleRoute(
          '/history/',
          module: HistoryModule(),
          transition: TransitionType.rightToLeft,
        ),
      ],
    ),
    ModuleRoute('/login/', module: AuthModule()),
  ];
}
