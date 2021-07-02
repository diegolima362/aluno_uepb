import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'app_controller.g.dart';

@Injectable()
class AppController = _AppControllerBase with _$AppController;

abstract class _AppControllerBase with Store {
  late final DataController storage;

  @observable
  bool darkMode = false;

  @observable
  int darkAccent = 0xfff2f2f7;

  @observable
  int lightAccent = 0xff1c1c1e;

  _AppControllerBase(this.storage) {
    storage.onThemeChanged.listen((e) => loadTheme());

    storage.onDarkAccentChanged.listen((e) {
      loadTheme();
    });

    storage.onLightAccentChanger.listen((e) {
      loadTheme();
    });

    loadTheme();
  }

  @action
  void setDarkMode(bool value) => darkMode = value;

  @action
  Future<void> loadTheme() async {
    darkMode = storage.themeMode;
    lightAccent = storage.lightAccentColorCode;
    darkAccent = storage.darkAccentColorCode;
  }
}
