import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';
import 'package:isar/isar.dart';
import 'package:workmanager/workmanager.dart';

import '../main.dart';
import 'modules/auth/atoms/auth_atom.dart';
import 'modules/auth/auth_module.dart';
import 'modules/courses/courses_module.dart';
import 'modules/home/ui/home_page.dart';
import 'modules/home/ui/landing_page.dart';
import 'modules/home/ui/select_implementation_page.dart';
import 'modules/preferences/preferences_module.dart';
import 'modules/profile/profile_module.dart';
import 'shared/data/datasources/remote_datasource.dart';
import 'shared/external/drivers/connectivity_driver.dart';
import 'shared/external/drivers/flutter_local_notification_driver.dart';
import 'shared/external/drivers/http_client.dart';
import 'shared/external/drivers/workmanager_driver.dart';
import 'shared/services/connectivity_service.dart';
import 'shared/services/notifications_service.dart';
import 'shared/services/worker_service.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        PreferencesModule(),
        AuthModule(),
        CoursesModule(),
        ProfileModule(),
      ];

  @override
  List<Bind> get binds => [
        Bind.instance<Isar>(isarInstance),
        Bind.singleton<FlutterSecureStorage>(
          (i) => const FlutterSecureStorage(),
        ),
        //
        Bind.singleton<IOClient>((i) {
          final httpClient = HttpClient()
            ..badCertificateCallback = (_, __, ___) => true;

          return IOClient(httpClient);
        }),
        Bind.lazySingleton((i) => AppHttpClient(i(), i())),
        //
        Bind.singleton((i) => Connectivity()),
        Bind.singleton((i) => ConnectivityDriver(i())),
        Bind.singleton((i) => ConnectivityService(i())),
        //
        Bind.instance<FlutterLocalNotificationsPlugin>(
            flutterLocalNotificationsPlugin),
        Bind.lazySingleton((i) => FlutterLocaltNotificationDriver(i())),
        Bind.lazySingleton((i) => NotificationsService(i())),
        //
        Bind.singleton((i) => Workmanager()),
        Bind.lazySingleton((i) => WorkManagerDriver(i())),
        Bind.lazySingleton((i) => WorkerService(i())),
        //

        Bind.singleton<AcademicRemoteDataSource>(
          (i) => GenericAcadamicRemoteDataSource(),
        ),
      ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      Modular.initialRoute,
      child: (context, args) => const LandingPage(),
    ),
    ChildRoute(
      '/select/',
      child: (context, args) => const SelectImplementationPage(),
    ),
    ModuleRoute('/auth/', module: AuthModule()),
    ChildRoute(
      '/app/',
      child: (context, args) => const HomePage(),
      children: [
        ModuleRoute('/courses/', module: CoursesModule()),
        ModuleRoute('/preferences/', module: PreferencesModule()),
      ],
      guards: [AppGuard()],
    ),
  ];
}

class AppGuard extends RouteGuard {
  AppGuard() : super(redirectTo: '/');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    return userState.value != null;
  }
}
