import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  Analytics._();

  static final instance = Analytics._();

  Future<void> onLogin() async {
    final FirebaseAnalytics analytics = FirebaseAnalytics();
    await analytics.logLogin();
  }

  Future<void> setUserProperties(Map<String, String> properties) async {
    final FirebaseAnalytics analytics = FirebaseAnalytics();

    await analytics.setUserId(properties['register']);

    await analytics.setUserProperty(
        name: 'gender', value: properties['gender']);

    await analytics.setUserProperty(
        name: 'campus', value: properties['campus']);

    await analytics.setUserProperty(
        name: 'program', value: properties['program']);

    await analytics.setUserProperty(
        name: 'building', value: properties['building']);

    await analytics.setUserProperty(name: 'idade', value: properties['age']);
  }
}
