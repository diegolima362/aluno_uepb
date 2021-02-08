import 'package:flutter_modular/flutter_modular.dart';

import 'landing_controller.dart';
import 'landing_page.dart';

class LandingModule extends ChildModule {
  @override
  List<Bind> get binds => [
        BindInject(
          (i) => LandingController(),
          singleton: true,
          lazy: true,
        ),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => LandingPage()),
      ];

  static Inject get to => Inject<LandingModule>.of();
}
