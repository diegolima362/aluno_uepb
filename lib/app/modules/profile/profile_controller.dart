import 'package:aluno_uepb/app/app_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'profile_controller.g.dart';

@Injectable()
class ProfileController = _ProfileControllerBase with _$ProfileController;

abstract class _ProfileControllerBase with Store {
  @observable
  bool isDark = false;

  @action
  void setTheme(bool value) {
    isDark = value;
    Modular.get<AppController>().tempSetTheme(value);
  }
}
