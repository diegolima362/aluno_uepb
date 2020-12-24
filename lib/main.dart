import 'package:aluno_uepb/app/app_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

const bool USE_FIRE_STORE_EMULATOR = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting("pt_BR", null);

  // await Firebase.initializeApp();

  // if (USE_FIRE_STORE_EMULATOR) {
  //   String host = defaultTargetPlatform == TargetPlatform.android
  //       ? '10.0.2.2:8080'
  //       : 'localhost:8080';
  //   FirebaseFirestore.instance.settings =
  //       Settings(host: host, sslEnabled: false, persistenceEnabled: false);
  // }

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();

  Hive.init(appDocumentDirectory.path);

  await Hive.openBox('login');

  runApp(ModularApp(module: AppModule()));
}
