import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/auth/repositories/auth_repository.dart';
import 'package:aluno_uepb/app/shared/event_logger/event_logger.dart';
import 'package:aluno_uepb/app/shared/notifications/notifications_manager.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_controller.dart';
import 'modules/home/home_module.dart';
import 'modules/landing/landing_module.dart';
import 'modules/login/login_module.dart';
import 'shared/repositories/data_controller.dart';
import 'shared/repositories/local_storage/hive_storage.dart';
import 'shared/themes/custom_themes.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => AppController()),
    Bind.singleton((i) => AuthRepository()),
    Bind.singleton((i) => AuthController()),
    Bind.lazySingleton((i) => HiveStorage()),
    Bind.lazySingleton((i) => DataController()),
    Bind.lazySingleton((i) => HiveStorage()),
    Bind.lazySingleton((i) => NotificationsManager()),
    Bind.lazySingleton((i) => EventLogger()),
    Bind.lazySingleton((i) => CustomThemes()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute('/', module: LandingModule()),
    ModuleRoute('/login', module: LoginModule()),
    ModuleRoute('/home', module: HomeModule()),
  ];
}
