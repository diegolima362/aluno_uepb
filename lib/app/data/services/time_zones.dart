import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

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
