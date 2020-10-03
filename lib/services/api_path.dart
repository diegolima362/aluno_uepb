import 'package:aluno_uepb/models/models.dart';
import 'package:diacritic/diacritic.dart';

class APIPath {
  static String profile(Profile profile) {
    final campus =
        removeDiacritics(profile.campus).toLowerCase().replaceAll(' ', '-');
    final register = profile.register;
    final building =
        removeDiacritics(profile.building).toLowerCase().split(' ');
    final program =
        removeDiacritics(profile.program).toLowerCase().replaceAll(' ', '-');

    final buffer = StringBuffer();

    building.forEach((e) {
      if (e.length > 2) buffer.write(e[0]);
    });

    return "users/$campus/building/${buffer.toString()}/$program/$register/";
  }
}
