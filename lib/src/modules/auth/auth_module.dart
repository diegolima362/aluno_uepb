import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/shared_module.dart';
import 'data/datasources/auth_datasources.dart';
import 'data/repositories/auth_repository.dart';
import 'external/datasources/auth_secure_storage_local_datasource.dart';
import 'reducers/auth_reducer.dart';
import 'ui/pages/sign_in_page.dart';
import 'ui/pages/sign_in_webview.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [SharedModule()];

  @override
  void exportedBinds(i) {
    i
      ..addSingleton<AuthLocalDataSource>(AuthSecureStorageLocalDataSource.new)
      ..addSingleton(AuthRepository.new)
      ..addSingleton(AuthReducer.new);
  }

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r
      ..child('/', child: (context) => const SignInPage())
      ..child(
        '/sign-in-webview/',
        child: (context) => SignInWebView(
          username: r.args.data['username'],
          password: r.args.data['password'],
        ),
      );
  }
}
