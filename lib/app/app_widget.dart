import 'dart:convert';

import 'package:aluno_uepb/app/shared/models/notification_model.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/themes/custom_themes.dart';
import 'package:asuka/asuka.dart' as asuka;
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
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

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
            builder: asuka.builder,
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

  @override
  void initState() {
    super.initState();
    _config();
    _configureSelectNotificationSubject();
  }

  Future<void> _config() async {
    Modular.get<INotificationsManager>()
        .notificationSubject
        .stream
        .listen((receivedNotification) async {
      await showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(receivedNotification.title),
          content: Text(receivedNotification.body),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                Modular.to.pushNamed(
                  'reminders/notifications/details',
                  arguments: receivedNotification,
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    Modular.get<INotificationsManager>()
        .selectNotificationSubject
        .stream
        .listen((payload) async {
      final notification = NotificationModel(
        id: 1,
        title: '',
        body: '',
        payload: payload,
      );

      await asuka.showDialog(
        builder: (context) {
          final map = json.decode(notification.payload);

          return AlertDialog(
            title: Text(map['title']),
            content: Text(map['courseName']),
          );
        },
      );
    });
  }
}
