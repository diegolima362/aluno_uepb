import 'package:aluno_uepb/app/shared/themes/custom_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_controller.dart';

class AppWidget extends StatelessWidget {
  final AppController controller;

  const AppWidget({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              controller.isDark ? Brightness.light : Brightness.dark,
        ));

        return MaterialApp(
          navigatorKey: Modular.navigatorKey,
          title: 'Aluno UEPB',
          themeMode: controller.themeMode,
          initialRoute: '/',
          onGenerateRoute: Modular.generateRoute,
          theme: controller.isDark ? CustomThemes.dark : CustomThemes.light,
        );
      },
    );
  }
}
