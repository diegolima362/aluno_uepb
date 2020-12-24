import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'landing_controller.g.dart';

@Injectable()
class LandingController = _LandingControllerBase with _$LandingController;

abstract class _LandingControllerBase with Store {
  _LandingControllerBase() {
    _auth = Modular.get<AuthController>();

    _auth.onAuthStateChanged.listen((e) {
      if (_auth.status == AuthStatus.loggedOn)
        goToHome();
      else
        goToLogin();
    });
  }

  AuthController _auth;

  @action
  void goToHome() {
    Modular.to.pushReplacementNamed('/home');
  }

  @action
  void goToLogin() {
    Modular.to.pushReplacementNamed('/login');
  }
}
