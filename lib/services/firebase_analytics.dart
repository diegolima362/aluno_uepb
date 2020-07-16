import 'package:firebase_analytics/firebase_analytics.dart';

class FirestoreAnalytics {
  FirestoreAnalytics._();

  static final instance = FirestoreAnalytics._();

  Future<void> onLogin() async {
    print('> login analytics');
    final FirebaseAnalytics analytics = FirebaseAnalytics();
    await analytics.logLogin();
  }

  Future<void> setUserProperties(Map<String, String> properties) async {
    final FirebaseAnalytics analytics = FirebaseAnalytics();

    await analytics.setUserId(properties['register']);

    await analytics.setUserProperty(
        name: 'gender', value: properties['gender']);

    await analytics.setUserProperty(
        name: 'birthDate', value: properties['birthDate']);

    await analytics.setUserProperty(
        name: 'campus', value: properties['campus']);

    await analytics.setUserProperty(
        name: 'program', value: properties['program']);

    await analytics.setUserProperty(
        name: 'building', value: properties['building']);

    await analytics.setUserProperty(name: 'idade', value: properties['age']);
  }
}
