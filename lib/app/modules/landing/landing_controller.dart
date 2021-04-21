import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/models/user_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'landing_controller.g.dart';

@Injectable()
class LandingController = _LandingControllerBase with _$LandingController;

abstract class _LandingControllerBase with Store {
  late final AuthController _auth;

  @observable
  UserModel? user;

  @observable
  bool isLoading = true;

  @observable
  bool isLogged = false;

  _LandingControllerBase() {
    setLoading(true);

    _auth = Modular.get<AuthController>();
    setUser(_auth.user);

    _auth.onAuthStateChanged.listen((e) {
      setUser(_auth.user);
      if (e == null) Modular.to.navigate('/');
    });

    setLoading(false);
  }

  @action
  void setUser(UserModel? value) {
    print('> _LandingControllerBase: user = $value');
    user = value;
    setIsLogged(_auth.status == AuthStatus.loggedOn);
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
    if (isLogged) goToHome();
  }

  @action
  void goToHome() {
    Modular.to.navigate('/home/content');
  }

  @action
  void goToLogin() {
    Modular.to.navigate('/login');
  }
}
