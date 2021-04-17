import 'dart:async';

import 'package:aluno_uepb/app/app_module.dart';
import 'package:aluno_uepb/app/app_widget.dart';
import 'package:aluno_uepb/app/shared/repositories/local_storage/hive_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting("pt_BR", null);

  await Firebase.initializeApp();

  await Hive.initFlutter();

  await HiveStorage.initDatabase();

  final currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}

const bool USE_FIRE_STORE_EMULATOR = false;
