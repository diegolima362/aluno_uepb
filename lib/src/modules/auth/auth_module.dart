import 'package:flutter_modular/flutter_modular.dart';

import 'data/datasources/auth_datasources.dart';
import 'data/repositories/auth_repository.dart';
import 'external/datasources/auth_secure_storage_local_datasource.dart';
import 'reducers/auth_reducer.dart';
import 'ui/pages/sign_in_page.dart';
import 'ui/pages/sign_in_webview.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [
    //
    Bind.singleton<AuthLocalDataSource>(
      (i) => AuthSecureStorageLocalDataSource(i()),
      export: true,
    ),
    //
    Bind.singleton((i) => AuthRepository(i(), i()), export: true),
    //
    Bind.singleton((i) => AuthReducer(i()), export: true),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => const SignInPage()),
    ChildRoute(
      '/sign-in-webview/',
      child: (_, args) => SignInWebView(
        username: args.data['username'],
        password: args.data['password'],
      ),
    ),
  ];
}
