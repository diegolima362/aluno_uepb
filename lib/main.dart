import 'dart:async';

import 'package:aluno_uepb/app/app_module.dart';
import 'package:aluno_uepb/app/app_widget.dart';
import 'package:aluno_uepb/app/shared/repositories/local_storage/hive_storage/hive_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'app/shared/repositories/remote_data/scraper/verify_changes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initializeDateFormatting("pt_BR", null);
  await _initPlugins();
  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}

Future<void> _initPlugins() async {
  await Workmanager().initialize(verifyChanges);

  await _configureLocalTimeZone();

  await Firebase.initializeApp();

  await Hive.initFlutter(HiveStorage.STORAGE_DIR);

  await HiveStorage.initDatabase();
}

Future _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  try {
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  } catch (e) {
    // Failed to get timezone or device is GMT or UTC, assign generic timezone
    const String fallback = 'America/Recife';
    print('Could not get a legit timezone, setting as $fallback');
    tz.setLocalLocation(tz.getLocation(fallback));
  }
}
