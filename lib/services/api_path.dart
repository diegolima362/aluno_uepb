import 'package:cau3pb/models/profile.dart';
import 'package:diacritic/diacritic.dart';

class APIPath {
  static String profile(Profile profile) {
    final campus = profile.campus.toLowerCase().replaceAll(' ', '-');
    final register = profile.register;
    final building = profile.building.toLowerCase().split(' ');
    final program =
        removeDiacritics(profile.program).toLowerCase().replaceAll(' ', '-');

    final buffer = new StringBuffer();

    building.forEach((e) {
      if (e.length > 2) buffer.write(e[0]);
    });

    return "users/$campus/${buffer.toString()}/$program/students/$register";
  }
}
