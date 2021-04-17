import 'package:flutter_modular/flutter_modular.dart';

import 'login_controller.dart';
import 'login_page.dart';

class LoginModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => LoginController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/login', child: (_, __) => LoginPage()),
  ];
}
