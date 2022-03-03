import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';

import 'app_widget.dart';
import 'core/external/drivers/connectivity_driver.dart';
import 'core/external/drivers/session.dart';
import 'core/infra/services/connectivity_service.dart';
import 'core/presenter/pages/landing/landing_page.dart';
import 'core/presenter/stores/auth_store.dart';
import 'core/presenter/stores/preferences_store.dart';
import 'core/presenter/widgets/responsive.dart';
import 'modules/auth/auth_module.dart';
import 'modules/auth/external/datasources/adapters/drift/drift_database.dart';
import 'modules/courses/courses_module.dart';
import 'modules/courses/external/datasouces/adapters/drift/drift_database.dart';
import 'modules/preferences/external/datasources/adapters/drift/drift_database.dart';
import 'modules/preferences/preferences_module.dart';
import 'modules/root/root_page.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        // dbs
        Bind.singleton((i) => PrefsDatabase()),
        Bind.singleton((i) => AuthDatabase()),
        Bind.singleton((i) => ContentDatabase()),

        // auth
        ...AuthModule.export,

        // courses
        ...CoursesModule.export,

        // preferences
        ...PreferencesModule.export,

        // core stores
        Bind.singleton((i) => AuthStore(i(), i())),
        Bind.singleton((i) => PreferencesStore(i(), i(), i(), i())),
        // services
        Bind.lazySingleton((i) => ConnectivityService(i())),
        // tools
        Bind.lazySingleton((i) => Client()),
        Bind.lazySingleton((i) => Session(i())),
        Bind.lazySingleton((i) => Connectivity()),
        Bind.lazySingleton((i) => ConnectivityDriver(i())),
        Bind.lazySingleton((i) => ResponsiveSize(globalContext)),
      ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (context, args) => LandingPage()),
    ChildRoute('/root/', child: (context, args) => const RootPage(), children: [
      ModuleRoute('/courses/', module: CoursesModule()),
      ModuleRoute('/preferences/', module: PreferencesModule()),
    ]),
    ModuleRoute('/login/', module: AuthModule()),
  ];
}
