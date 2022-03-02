import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3_library_windows/sqlite3_library_windows.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';

const debugLayoutMode = true;

void main() {
  open.overrideFor(OperatingSystem.windows, openSQLiteOnWindows);

  runApp(
    DevicePreview(
      enabled: debugLayoutMode,
      builder: (context) => ModularApp(
        module: AppModule(),
        child: Responsive(context: debugLayoutMode ? context : null),
      ),
    ),
  );
}
