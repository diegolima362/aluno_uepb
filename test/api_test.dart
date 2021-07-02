import 'package:aluno_uepb/app/shared/repositories/remote_data/api/remote_scraper.dart';
import 'package:aluno_uepb/app/shared/repositories/remote_data/interfaces/remote_data_interface.dart';
import 'package:flutter_test/flutter_test.dart';

final user = '';
final pass = '';

main() {
  test('Should throw ArgumentError', () async {
    final IRemoteData s = RemoteScraper('user', 'pass');
    expect(() async => await s.getCourses(), throwsArgumentError);
  });

  test('Register value should be equal user', () async {
    final IRemoteData s = RemoteScraper(user, pass);

    final profile = await s.getProfile();

    expect(profile, isNotNull);
    expect(profile!['register'], user);
  });

  test('Should return same number of course as defined', () async {
    int expectedCourses = 6;

    final IRemoteData s = RemoteScraper(user, pass);

    final courses = await s.getCourses();

    expect(courses, isNotNull);
    expect(courses!.length, expectedCourses);
  });
}
