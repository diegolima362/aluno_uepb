import 'package:aluno_uepb/app/app_controller.dart';
import 'package:aluno_uepb/app/app_widget.dart';
import 'package:aluno_uepb/app/modules/home/home_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        BindInject(
          (i) => AppController(),
          singleton: true,
          lazy: true,
        ),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, module: HomeModule()),
      ];

  @override
  Widget get bootstrap => AppWidget(controller: to.get());

  static Inject get to => Inject<AppModule>.of();
}
