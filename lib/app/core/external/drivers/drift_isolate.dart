import 'dart:io';
import 'dart:isolate';

import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

DatabaseConnection createDriftIsolateAndConnect() {
  return DatabaseConnection.delayed(() async {
    final isolate = await createDriftIsolate();
    return await isolate.connect();
  }());
}

Future<DriftIsolate> createDriftIsolate() async {
  if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();

  final prefs = await SharedPreferences.getInstance();

  var path = '';

  try {
    final dir = await getApplicationDocumentsDirectory();
    path = p.join(dir.path, 'aluno_uepb', 'database', 'app_db.sqlite');
    await prefs.setString('path', path);
  } on MissingPluginException catch (e) {
    path = prefs.getString('path') ?? '';
    debugPrint('> VerifyChanges: ${e.message}');
  }

  final receivePort = ReceivePort();

  await Isolate.spawn(
    _startBackground,
    _IsolateStartRequest(receivePort.sendPort, path),
  );

  return await receivePort.first as DriftIsolate;
}

void _startBackground(_IsolateStartRequest request) {
  final executor = NativeDatabase(File(request.targetPath));

  final driftIsolate = DriftIsolate.inCurrent(
    () => DatabaseConnection.fromExecutor(executor),
  );

  request.sendDriftIsolate.send(driftIsolate);
}

class _IsolateStartRequest {
  final SendPort sendDriftIsolate;
  final String targetPath;

  _IsolateStartRequest(this.sendDriftIsolate, this.targetPath);
}
