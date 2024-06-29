import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> askForPermissions() async {
  if (!kIsWeb && Platform.isAndroid) {
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      await Permission.locationWhenInUse.request();
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    status = await Permission.nearbyWifiDevices.status;
    if (status.isDenied) {
      await Permission.nearbyWifiDevices.request();
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}
