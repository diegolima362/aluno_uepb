import 'package:aluno_uepb/app/modules/routes.dart';
import 'package:aluno_uepb/app/shared/notifications/local_notification/notifications_manager.dart';
import 'package:aluno_uepb/app/shared/themes/custom_themes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_controller.dart';

class AppWidget extends StatefulWidget {
  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends ModularState<AppWidget, AppController> {
  @override
  void initState() {
    super.initState();
    _configureSelectNotificationSubject();
  }

  @override
  void dispose() {
    NotificationsManager().selectNotificationSubject.close();
    super.dispose();
  }

  static final analytics = FirebaseAnalytics();
  static final observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    final themes = Modular.get<CustomThemes>();

    return Observer(
      builder: (_) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              controller.darkMode ? Brightness.light : Brightness.dark,
        ));

        final themeMode =
            controller.darkMode ? ThemeMode.dark : ThemeMode.light;

        return NotificationListener<OverscrollIndicatorNotification>(
          child: MaterialApp(
            localizationsDelegates: [GlobalMaterialLocalizations.delegate],
            supportedLocales: [const Locale('en'), const Locale('pt', 'BR')],
            debugShowCheckedModeBanner: false,
            title: 'Aluno UEPB',
            navigatorObservers: <NavigatorObserver>[observer],
            themeMode: themeMode,
            theme: themes.getLight(colorValue: controller.lightAccent),
            darkTheme: themes.getDark(colorValue: controller.darkAccent),
          ).modular(),
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return false;
          },
        );
      },
    );
  }

  void _configureSelectNotificationSubject() {
    NotificationsManager()
        .selectNotificationSubject
        .stream
        .listen((payload) async {
      await Modular.to.pushNamed(NOTIFICATION, arguments: payload);
    });
  }
}
