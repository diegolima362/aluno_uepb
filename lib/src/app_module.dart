import 'package:flutter_modular/flutter_modular.dart';

import 'modules/auth/atoms/auth_atom.dart';
import 'modules/auth/auth_module.dart';
import 'modules/courses/courses_module.dart';
import 'modules/home/ui/home_page.dart';
import 'modules/home/ui/landing_page.dart';
import 'modules/home/ui/select_implementation_page.dart';
import 'modules/preferences/preferences_module.dart';
import 'shared/data/datasources/remote_datasource.dart';
import 'shared/shared_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        SharedModule(),
        PreferencesModule(),
        AuthModule(),
      ];

  @override
  void binds(i) {
    final generic = GenericAcadamicRemoteDataSource();

    i
      ..addInstance<GenericAcadamicRemoteDataSource>(generic)
      ..addInstance<AcademicRemoteDataSource>(generic);
  }

  @override
  void routes(r) {
    r
      ..child('/', child: (context) => const LandingPage())
      ..child('/select/', child: (context) => const SelectImplementationPage())
      ..module('/auth', module: AuthModule())
      ..child(
        '/app',
        child: (context) => const HomePage(),
        children: [
          ModuleRoute('/courses', module: CoursesModule()),
          ModuleRoute('/preferences', module: PreferencesModule()),
        ],
        guards: [AppGuard()],
      );
  }
}

class AppGuard extends RouteGuard {
  AppGuard() : super(redirectTo: '/');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    return userState.value != null;
  }
}
