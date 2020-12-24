import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'executors/login_executor.dart';

class AuthGuard extends RouteGuard {
  final AuthController auth = Modular.get();

  @override
  bool canActivate(String url) {
    print(url);
    // if (url.contains('/login')) {
    //   if (auth.status == AuthStatus.loggedOn) {
    //     return false;
    //   }
    //   return true;
    // }
    //
    // if (auth.status == AuthStatus.loggedOn) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  @override
  List<GuardExecutor> get executors => [LoginExecutor()];
}
