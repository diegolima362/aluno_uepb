import 'package:asp/asp.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:isar/isar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import 'package:workmanager/workmanager.dart';

import 'src/app_module.dart';
import 'src/app_widget.dart';
import 'src/modules/courses/external/schema.dart';
import 'src/modules/preferences/external/datasources/schema.dart';
import 'src/modules/profile/external/schema.dart';
import 'src/shared/data/datasources/remote_datasource.dart';
import 'src/shared/data/types/open_protocol.dart';
import 'src/shared/external/datasources/implementations.dart';
import 'src/shared/services/background_worker.dart';

const debugLayoutMode = false; //kDebugMode;
const devMode = false;

late final String appName;
late final String packageName;
late final String appVersion;
late final String buildNumber;

late final Isar isarInstance;
late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

late final AppModule appModule;

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initialization();

  appModule = AppModule();

  runApp(
    DevicePreview(
      enabled: debugLayoutMode,
      builder: (BuildContext context) {
        return RxRoot(
          child: ModularApp(
            module: appModule,
            child: const AppWidget(),
          ),
        );
      },
    ),
  );
}

Future<void> initialization() async {
  //

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  appName = packageInfo.appName;
  packageName = packageInfo.packageName;
  appVersion = packageInfo.version;
  buildNumber = packageInfo.buildNumber;

  //
  isarInstance = await initializeIsar();

  await initializeLocalTimeZone();
  await initializeNotifications();

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: devMode,
  );
}

Future initializeLocalTimeZone() async {
  initializeTimeZones();

  final timeZoneName = await FlutterTimezone.getLocalTimezone();
  try {
    setLocalLocation(getLocation(timeZoneName));
  } catch (e) {
    const String fallback = 'America/Recife';
    debugPrint('> Could not get a legit timezone, setting as $fallback');
    setLocalLocation(getLocation(fallback));
  }
}

Future<void> initializeNotifications() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const androidSettings = AndroidInitializationSettings('notification_icon');

  const initializationSettings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

Future<Isar> initializeIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  final ins = Isar.getInstance();

  return ins ??
      await Isar.open(directory: dir.path, [
        IsarPreferencesModelSchema,
        IsarCourseModelSchema,
        IsarHistoryModelSchema,
        IsarProfileModelSchema,
      ]);
}

bool postInitCalled = false;
void replaceImplementation(DataSourceImplementation implementation,
    [OpenProtocolSpec? spec]) {
  // final datasource = Modular.get<GenericAcadamicRemoteDataSource>();

  final datasource = Modular.get<AcademicRemoteDataSource>()
      as GenericAcadamicRemoteDataSource;

  if (implementation != DataSourceImplementation.none) {
    final impl = getRemoteDataSourceImplementation(implementation, spec);
    datasource.setImplementation(impl);
  } else {
    datasource.setImplementation(null);
  }
}
