import 'dart:io';

import 'package:aluno_uepb/app/shared/repositories/remote_data/interfaces/remote_data_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/remote_data/scraper/scraper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart' as pp;

final user = '';
final pass = '';

main() {
  test('Register value should be equal user', () async {
    final IRemoteData s = Scraper(user: user, password: pass);

    final profile = await s.getProfile();

    expect(profile, isNotNull);
    expect(profile!['register'], user);
  });

  test('Should return same number of course as defined', () async {
    int expectedCourses = 6;

    final IRemoteData s = Scraper(user: user, password: pass);

    final courses = await s.getCourses();

    expect(courses, isNotNull);
    expect(courses!.length, expectedCourses);
  });

  test('Register value should be equal user - Mock', () async {
    final IRemoteData s = Scraper(user: user, password: pass, debugMode: true);

    final profile = await s.getProfile();

    expect(profile, isNotNull);
    expect(profile!['register'], user);
  });

  test('Should return same number of course as defined - Mock', () async {
    int expectedCourses = 6;

    final IRemoteData s = Scraper(user: user, password: pass, debugMode: true);

    final courses = await s.getCourses();

    print(courses);

    expect(courses, isNotNull);
    expect(courses!.length, expectedCourses);
  });

  test('Should download a file', () async {
    final IRemoteData s = Scraper(user: user, password: pass, debugMode: true);

    final data = await s.downloadRDM();

    if (data != null) {
      final path = (await pp.getApplicationDocumentsDirectory()).path;
      final file = File('$path/rdm.html');
      file.writeAsBytes(data);
    }
  });
}
