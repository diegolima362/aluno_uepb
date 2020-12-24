import 'package:aluno_uepb/app/shared/repositories/local_storage/interfaces/local_storage_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'app_controller.g.dart';

@Injectable()
class AppController = _AppControllerBase with _$AppController;

abstract class _AppControllerBase with Store {
  _AppControllerBase() {
    storage = Modular.get();

    storage.onThemeChanged.listen((e) => loadTheme());

    loadTheme();
  }

  ILocalStorage storage;

  @observable
  ThemeData themeType;

  @observable
  ThemeMode themeMode;

  @computed
  bool get isDark => themeType.brightness == Brightness.dark;

  @action
  Future<void> loadTheme() async {
    final isDarkMode = storage.isDarkMode;

    if (isDarkMode) {
      print('> theme is dark');
      themeType = ThemeData.dark();
      themeMode = ThemeMode.dark;
    } else {
      print('> theme is light');
      themeType = ThemeData.light();
      themeMode = ThemeMode.light;
    }
  }
}
