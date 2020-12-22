import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'app_controller.g.dart';

@Injectable()
class AppController = _AppControllerBase with _$AppController;

abstract class _AppControllerBase with Store {
  _AppControllerBase() {
    // darkThemePreference = Modular.get();
    loadTheme();
  }

  // ILocalStorage darkThemePreference;

  @observable
  ThemeData themeType;

  @observable
  ThemeMode themeMode;

  @computed
  bool get isDark => themeType.brightness == Brightness.dark;

  bool tempThemeMode = false;

  void tempSetTheme(bool value) {
    print('> is dark: $value');
    tempThemeMode = value;
    loadTheme();
  }

  @action
  Future<void> loadTheme() async {
    // final prefs = await darkThemePreference.isDarkTheme();

    final prefs = tempThemeMode;

    if (prefs) {
      themeType = ThemeData.dark();
      themeMode = ThemeMode.dark;
    } else {
      themeType = ThemeData.light();
      themeMode = ThemeMode.light;
    }
  }
}
