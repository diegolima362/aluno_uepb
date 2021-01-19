import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'details/details_controller.dart';
import 'details/details_page.dart';
import 'rdm_controller.dart';
import 'rdm_page.dart';

class RdmModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        BindInject(
          (i) => RdmController(),
          singleton: true,
          lazy: true,
        ),
        BindInject(
          (i) => DetailsController(),
          singleton: true,
          lazy: true,
        ),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => RdmPage()),
        ModularRouter('details', child: (_, args) => DetailsPage()),
      ];

  static Inject get to => Inject<RdmModule>.of();

  Widget get view => RdmPage();
}
