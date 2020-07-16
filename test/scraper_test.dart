import 'package:cau3pb/services/scraper/scraper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('scraper - profile', () async {
    final scraper = Scraper(user: 'user', password: 'password');

    Map<String, dynamic> profile;
    try {
      profile = await scraper.getProfile();
    } catch (e) {
      rethrow;
    }
  });

  test('scraper - courses', () async {
    final scraper = Scraper(user: 'user', password: 'password');

    List<Map<String, dynamic>> courses;

    try {
      courses = await scraper.getCourses();
    } catch (e) {
      rethrow;
    }
  });

  test('scraper - allData', () async {
    final scraper = Scraper(user: '172030552', password: '20032000');

    var data;

    try {
      data = {
        await scraper.getAllData(),
//        await scraper.getCourses(),
      };
    } catch (e) {
      rethrow;
    }

    print(data);
  });
}
