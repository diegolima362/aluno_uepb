import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/auth/authenticator/scraper_auth/authenticator.dart';
import 'package:aluno_uepb/app/shared/auth/repositories/secure_storage/auth_repository.dart';
import 'package:aluno_uepb/app/shared/repositories/local_storage/interfaces/local_storage_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/remote_data/interfaces/remote_data_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/remote_data/scraper/scraper.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_controller.dart';
import 'modules/home/home_module.dart';
import 'modules/landing/landing_page.dart';
import 'modules/login/login_module.dart';
import 'modules/notifications/notification_details_page.dart';
import 'modules/routes.dart' as global;
import 'shared/notifications/local_notification/notifications_manager.dart';
import 'shared/repositories/data_controller.dart';
import 'shared/repositories/local_storage/hive_storage/hive_storage.dart';
import 'shared/themes/custom_themes.dart';

class AppModule extends Module {
  static final _debugMode = false;

  @override
  final List<Bind> binds = [
    Bind.singleton((i) => AppController(i.get<DataController>())),
    Bind.singleton(
      (i) => AuthController(
        i.get<FlutterSecureStorageRepository>(),
        i.get<ScraperAuthenticator>(),
      ),
    ),
    Bind.lazySingleton(
      (i) => DataController(
        storage: i.get<ILocalStorage>(),
        auth: i.get<AuthController>(),
        remoteData: i.get<IRemoteData>(),
      ),
    ),
    Bind.singleton((i) => FlutterSecureStorageRepository()),
    Bind.singleton((i) => ScraperAuthenticator(debugMode: _debugMode)),
    Bind.lazySingleton((i) => HiveStorage()),
    Bind.lazySingleton((i) => CustomThemes()),
    Bind.lazySingleton((i) => NotificationsManager()),
    Bind.lazySingleton((i) => Scraper(debugMode: _debugMode)),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (ctx, args) => LandingPage()),
    ModuleRoute(global.LOGIN, module: LoginModule()),
    ModuleRoute(global.HOME, module: HomeModule()),
    ChildRoute(
      global.NOTIFICATION,
      child: (ctx, args) => NotificationDetailsPage(payload: args.data),
    ),
  ];
}
