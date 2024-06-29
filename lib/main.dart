import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'app/app_widget.dart';
import 'app/data/datasources/local/secure_storage/secure_storage.dart';
import 'app/data/datasources/local/sqflite/sqflite_database.dart';
import 'app/data/services/http_client.dart';
import 'app/data/services/local_notification_service.dart';
import 'app/data/services/worker.dart';
import 'app/injector.dart';

const debugLayoutMode = false; //kDebugMode;
const devMode = false;

late final String appName;
late final String packageName;
late final String appVersion;
late final String buildNumber;

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initialization();

  runApp(const AppWidget());
}

Future<void> initialization() async {
  //
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  appName = packageInfo.appName;
  packageName = packageInfo.packageName;
  appVersion = packageInfo.version;
  buildNumber = packageInfo.buildNumber;

  //
  await initializeSecureStorage();
  await initializeSqflite();
  initAppHttpClient();

  await initializeNotifications();
  await initializeWorker();

  initializeAutoInjector();
}
