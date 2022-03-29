import 'package:aluno_uepb/app/core/external/drivers/drift_isolate.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';
import 'app/core/external/datasources/verify_changes.dart';

const debugLayoutMode = false;
late final SharedPreferences prefs;

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initialization();

  runApp(
    DevicePreview(
      enabled: debugLayoutMode,
      builder: (context) => ModularApp(
        module: AppModule(prefs: prefs),
        child: Responsive(context: debugLayoutMode ? context : null),
      ),
    ),
  );
}

Future<void> initialization() async {
  prefs = await SharedPreferences.getInstance();

  await Workmanager().initialize(verifyChanges);

  await _configureLocalTimeZone();

  await _initializeNotifications();

  await createDriftIsolate();
}

Future _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  try {
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  } catch (e) {
    const String fallback = 'America/Recife';
    debugPrint('> Could not get a legit timezone, setting as $fallback');
    tz.setLocalLocation(tz.getLocation(fallback));
  }
}

Future<void> _initializeNotifications() async {
  final plugin = FlutterLocalNotificationsPlugin();

  const androidSettings = AndroidInitializationSettings('notification_icon');

  const initializationSettings = InitializationSettings(
    android: androidSettings,
  );

  await plugin.initialize(
    initializationSettings,
  );
}
