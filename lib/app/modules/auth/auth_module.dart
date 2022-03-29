import 'package:flutter_modular/flutter_modular.dart';

import 'domain/usecases/usecases.dart';
import 'external/datasources/auth_datasource.dart';
import 'infra/repositories/auth_repository.dart';
import 'presenter/login/login_page.dart';
import 'presenter/login/login_store.dart';

class AuthModule extends Module {
  static List<Bind> export = [
    // usecases
    Bind.lazySingleton((i) => GetLoggedUser(i())),
    Bind.lazySingleton((i) => SignedSession(i(), i())),
    Bind.lazySingleton((i) => Logout(i())),
    // repositories
    Bind.lazySingleton((i) => AuthRepository(i())),
    // datasources
    Bind.lazySingleton((i) => AuthDatasource(i(), i())),
  ];

  @override
  final List<Bind> binds = [
    // usecases
    Bind.lazySingleton((i) => SignIn(i(), i())),
    //stores
    Bind.lazySingleton((i) => LoginStore(i(), i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => const LoginPage()),
  ];
}
