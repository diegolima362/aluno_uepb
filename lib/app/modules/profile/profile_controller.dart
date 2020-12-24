import 'package:aluno_uepb/app/app_controller.dart';
import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'profile_controller.g.dart';

@Injectable()
class ProfileController = _ProfileControllerBase with _$ProfileController;

abstract class _ProfileControllerBase with Store {
  _ProfileControllerBase() {
    _authController = Modular.get();
    user = _authController.user;
  }

  AuthController _authController;
  UserModel user;

  @observable
  bool isDark = false;

  @action
  void setTheme(bool value) {
    isDark = value;
    Modular.get<AppController>().tempSetTheme(value);
  }

  @action
  void signOut() {
    _authController.signOut();
  }
}
