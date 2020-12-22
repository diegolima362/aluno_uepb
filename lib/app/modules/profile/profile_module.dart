import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'profile_controller.dart';
import 'profile_page.dart';

class ProfileModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        BindInject(
          (i) => ProfileController(),
          singleton: true,
          lazy: true,
        ),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => ProfilePage()),
      ];

  static Inject get to => Inject<ProfileModule>.of();

  Widget get view => ProfilePage();
}
