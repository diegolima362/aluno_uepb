import 'package:aluno_uepb/app/app_controller.dart';
import 'package:aluno_uepb/app/app_widget.dart';
import 'package:aluno_uepb/app/modules/home/home_module.dart';
import 'package:aluno_uepb/app/modules/profile/profile_module.dart';
import 'package:aluno_uepb/app/modules/rdm/rdm_module.dart';
import 'package:aluno_uepb/app/modules/reminders/reminders_module.dart';
import 'package:aluno_uepb/app/shared/repositories/local_storage/hive_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/landing/landing_module.dart';
import 'modules/login/login_module.dart';
import 'shared/auth/auth_controller.dart';
import 'shared/auth/repositories/auth_repository.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        BindInject(
          (i) => AppController(),
          singleton: true,
          lazy: true,
        ),
        BindInject(
          (i) => AuthRepository(),
          singleton: true,
          lazy: true,
        ),
        BindInject(
          (i) => AuthController(),
          singleton: true,
          lazy: true,
        ),
        BindInject(
          (i) => HiveStorage(),
          singleton: true,
          lazy: true,
        ),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          '/',
          module: LandingModule(),
          transition: TransitionType.noTransition,
        ),
        ModularRouter(
          '/login',
          module: LoginModule(),
          transition: TransitionType.noTransition,
        ),
        ModularRouter(
          '/home',
          module: HomeModule(),
          transition: TransitionType.noTransition,
        ),
        ModularRouter(
          '/rdm',
          module: RdmModule(),
          transition: TransitionType.noTransition,
        ),
        ModularRouter(
          '/reminders',
          module: RemindersModule(),
          transition: TransitionType.noTransition,
        ),
        ModularRouter(
          '/profile',
          module: ProfileModule(),
          transition: TransitionType.noTransition,
        ),
      ];

  @override
  Widget get bootstrap => AppWidget(controller: to.get());

  static Inject get to => Inject<AppModule>.of();
}
