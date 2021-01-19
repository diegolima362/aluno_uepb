import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/models/user_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'landing_controller.g.dart';

@Injectable()
class LandingController = _LandingControllerBase with _$LandingController;

abstract class _LandingControllerBase with Store {
  _LandingControllerBase() {
    _auth = Modular.get<AuthController>();

    setLoading(true);
    setIsLogged(_auth.status == AuthStatus.loggedOn);
    setUser(_auth.user);

    _auth.onAuthStateChanged.listen((e) {
      if (_auth.status == AuthStatus.loggedOn) {
        setUser(_auth.user);

        setIsLogged(true);
        goToHome();
        setLoading(false);
      } else {
        setUser(_auth.user);

        setLoading(false);
        setIsLogged(false);
        goToLogin();
      }
    });
  }

  AuthController _auth;

  @observable
  UserModel user;

  @observable
  bool isLoading;

  @observable
  bool isLogged;

  @action
  void setUser(UserModel value) {
    print('> _LandingControllerBase: user = $value');

    user = value;
  }

  @action
  void setLoading(bool value) {
    print('> _LandingControllerBase: loading = $value');

    isLoading = value;
  }

  @action
  void setIsLogged(bool value) {
    print('> _LandingControllerBase: isLogged = $value');

    isLogged = value;
  }

  @action
  void goToHome() {
    Modular.to.popAndPushNamed('/home');
  }

  @action
  void goToLogin() {
    Modular.to.popAndPushNamed('/login');
  }
}
