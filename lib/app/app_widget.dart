import 'dart:convert';

import 'package:aluno_uepb/app/shared/event_logger/interfaces/event_logger_interface.dart';
import 'package:aluno_uepb/app/shared/models/notification_model.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/themes/custom_themes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_controller.dart';

class AppWidget extends StatefulWidget {
  final AppController controller;

  const AppWidget({Key key, this.controller}) : super(key: key);

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
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
              widget.controller.isDark ? Brightness.light : Brightness.dark,
        ));

        var _theme = widget.controller.darkMode
            ? themes.getDark(colorValue: widget.controller.darkAccent)
            : themes.getLight(colorValue: widget.controller.lightAccent);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: Modular.navigatorKey,
          title: 'Aluno UEPB',
          initialRoute: Modular.initialRoute,
          onGenerateRoute: Modular.generateRoute,
          navigatorObservers: <NavigatorObserver>[observer],
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          ),
          themeMode: widget.controller.themeMode,
          theme: _theme,
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
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
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
      Modular.get<IEventLogger>().logEvent('logLaunchByReminder');

      final notification = NotificationModel(
        id: 1,
        title: '',
        body: '',
        payload: payload,
      );

      await Modular.to.showDialog(
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
