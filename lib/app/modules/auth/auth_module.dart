import 'package:flutter_modular/flutter_modular.dart';

import 'domain/usecases/usecases.dart';
import 'external/datasources/auth_datasource.dart';
import 'infra/repositories/auth_repository.dart';
import 'presenter/pages/login_page/login_page.dart';
import 'presenter/pages/login_page/login_store.dart';

class AuthModule extends Module {
  static List<Bind> export = [
    // usecases
    Bind.singleton((i) => GetLoggedUser(i())),
    Bind.singleton((i) => Logout(i())),
    // repositories
    Bind.singleton((i) => AuthRepository(i())),
    // datasources
    Bind.singleton((i) => AuthDatasource(i(), i())),
  ];

  @override
  final List<Bind> binds = [
    // usecases
    Bind.singleton((i) => SignIn(i(), i())),
    //stores
    Bind.singleton((i) => LoginStore(i(), i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => const LoginPage()),
  ];
}
