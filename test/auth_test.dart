import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

final user = '';
final pass = '';

main() async {
  test('should save and rea user', () async {
    final storage = await SharedPreferences.getInstance();

    await storage.setString(
      'user',
      json.encode({'user': user, 'password': pass}),
    );
    final result = storage.getString('user');
    print(result);
  });

  // final auth = AuthController(AuthRepository(), ScraperAuthenticator());

  // test('Should be not authenticated', () async {
  //   expect(auth.user?.logged ?? false, false);
  // });

  // test('Should be not authenticated then, authenticated', () async {
  //   expect(auth.user?.logged ?? false, false);
  //   await auth.signInWithIdPassword(id: user, password: pass);
  //   expect(auth.user?.logged ?? false, true);
  // });

  // tearDown(() async => await auth.signOut());
}
