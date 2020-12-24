import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'login_controller.g.dart';

@Injectable()
class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  _LoginControllerBase() {
    final auth = Modular.get<AuthController>();

    auth.onAuthStateChanged.listen((e) {
      if (e != null && auth.status == AuthStatus.loggedOn)
        Modular.to.pushReplacementNamed('/home');
    });
  }

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
