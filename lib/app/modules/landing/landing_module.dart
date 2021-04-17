import 'package:flutter_modular/flutter_modular.dart';

import 'landing_controller.dart';
import 'landing_page.dart';

class LandingModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => LandingController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/login', child: (_, __) => LandingPage()),
  ];
}
