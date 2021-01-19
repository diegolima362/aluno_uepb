import 'package:aluno_uepb/app/modules/home_content/full_schedule/full_schedule_controller.dart';
import 'package:aluno_uepb/app/modules/home_content/full_schedule/full_schedule_page.dart';
import 'package:aluno_uepb/app/modules/home_content/home_content_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_content_controller.dart';

class HomeContentModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        BindInject(
          (i) => HomeContentController(),
          singleton: true,
          lazy: true,
        ),
        BindInject(
          (i) => FullScheduleController(),
          singleton: true,
          lazy: true,
        ),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter('/', child: (_, args) => HomeContentPage()),
        ModularRouter('/all', child: (_, args) => FullSchedulePage()),
      ];

  static Inject get to => Inject<HomeContentModule>.of();

  @override
  Widget get view => HomeContentPage();
}
