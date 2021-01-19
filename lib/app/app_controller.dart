import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'app_controller.g.dart';

@Injectable()
class AppController = _AppControllerBase with _$AppController;

abstract class _AppControllerBase with Store {
  DataController storage;

  @observable
  ThemeData themeType;

  @observable
  ThemeMode themeMode;

  @observable
  bool darkMode;

  @observable
  int darkAccent;

  @observable
  int lightAccent;

  _AppControllerBase() {
    storage = Modular.get();

    storage.onThemeChanged.listen((e) => loadTheme());

    storage.onDarkAccentChanged.listen((e) {
      return loadTheme();
    });

    storage.onLightAccentChanger.listen((e) {
      return loadTheme();
    });

    loadTheme();
  }

  @computed
  bool get isDark => themeType.brightness == Brightness.dark;

  @action
  Future<void> loadTheme() async {
    darkMode = storage.themeMode;
    lightAccent = storage.lightAccentColorCode;
    darkAccent = storage.darkAccentColorCode;

    if (darkMode) {
      themeType = ThemeData.dark();
      themeMode = ThemeMode.dark;
    } else {
      themeType = ThemeData.light();
      themeMode = ThemeMode.light;
    }
  }
}
