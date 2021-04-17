import 'package:flutter_modular/flutter_modular.dart';

import 'details/details_controller.dart';
import 'details/details_page.dart';
import 'rdm_controller.dart';
import 'rdm_page.dart';

class RdmModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => RdmController()),
    Bind.singleton((i) => DetailsController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => RdmPage()),
    ChildRoute('details', child: (_, args) => DetailsPage()),
  ];
}
