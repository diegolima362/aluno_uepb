import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

final user = '';
final pass = '';

main() async {
  test('should save and rea user', () async {
    final storage = FlutterSecureStorage();

    await storage.write(
      key: 'user',
      value: json.encode({'user': user, 'password': pass}),
    );
    final result = await storage.read(key: 'user');
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
