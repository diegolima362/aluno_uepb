import 'package:aluno_uepb/app/modules/home/home_content/home_content_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_controller.dart';
import 'home_page.dart';

class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [
        BindInject(
          (i) => HomeController(),
          singleton: true,
          lazy: true,
        ),
        BindInject(
          (i) => HomeContentController(),
          singleton: true,
          lazy: true,
        ),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => HomePage()),
      ];

  static Inject get to => Inject<HomeModule>.of();
}
