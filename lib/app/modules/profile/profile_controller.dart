import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/repositories/local_storage/interfaces/local_storage_interface.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'profile_controller.g.dart';

@Injectable()
class ProfileController = _ProfileControllerBase with _$ProfileController;

abstract class _ProfileControllerBase with Store {
  _ProfileControllerBase() {
    _authController = Modular.get();
    _storage = Modular.get();

    user = _authController.user;
    setTheme(_storage.isDarkMode);
  }

  AuthController _authController;
  ILocalStorage _storage;
  UserModel user;

  @observable
  bool isDark = false;

  @action
  void setTheme(bool value) {
    _storage.setDarkMode(value);
    isDark = value;
  }

  @action
  void signOut() {
    _authController.signOut();
  }
}
