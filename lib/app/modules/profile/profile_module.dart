import 'package:aluno_uepb/app/modules/profile/history/history_controller.dart';
import 'package:aluno_uepb/app/modules/profile/history/history_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'details/details_page.dart';
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
        BindInject(
          (i) => HistoryController(),
          singleton: true,
          lazy: true,
        ),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => ProfilePage()),
        ModularRouter('details', child: (_, args) => DetailsPage()),
        ModularRouter('history', child: (_, args) => HistoryPage()),
      ];

  static Inject get to => Inject<ProfileModule>.of();

  Widget get view => ProfilePage();
}
