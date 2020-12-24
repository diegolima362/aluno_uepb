import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginExecutor extends GuardExecutor {
  @override
  onGuarded(String path, {bool isActive}) {
    final AuthController auth = Modular.get();

    // if (path.contains('/login')) {
    //   if (auth.status == AuthStatus.loggedOn) {
    //     print('Access blocked!');
    //
    //     Modular.to.pushReplacementNamed('/');
    //     return;
    //   }
    // }

    if (isActive) {
      print('Access allowed');
      return;
    }

    print('Access blocked!');
    Modular.to.pushReplacementNamed('/login');
  }
}
