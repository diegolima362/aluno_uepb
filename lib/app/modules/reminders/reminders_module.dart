import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'reminders_controller.dart';
import 'reminders_page.dart';

class RemindersModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        BindInject(
          (i) => RemindersController(),
          singleton: true,
          lazy: true,
        ),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => RemindersPage()),
      ];

  static Inject get to => Inject<RemindersModule>.of();

  Widget get view => RemindersPage();
}
