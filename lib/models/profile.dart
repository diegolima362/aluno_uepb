import 'package:aluno_uepb/services/services.dart';
import 'package:diacritic/diacritic.dart';

class Profile {
  final String register;
  final String name;
  String cra;
  String cumulativeCh;

  String viewName;
  final DateTime birthDate;

  String program;
  String campus;
  String building;

  final String gender;

  Profile(
    this.name,
    this.register, {
    this.cra = '-',
    this.cumulativeCh = '-',
    this.viewName,
    this.birthDate,
    this.campus,
    this.gender,
    this.program,
    this.building,
  });

  int get age {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }

    return age;
  }

  String get fBirthDate => Format.dateFirebase(birthDate).toString();

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'register': this.register,
      'cra': this.cra,
      'age': this.age,
      'cumulativeCH': this.cumulativeCh,
      'viewName': this.viewName,
      'birthDate': this.fBirthDate,
      'campus': this.campus,
      'gender': this.gender,
      'program': this.program,
      'building': this.building,
    };
  }

  Map<String, String> toMapFirestore() {
    final campus = this.campus.toLowerCase().replaceAll(' ', '');
    final building = this.building.toLowerCase().split(' ');
    final program =
        removeDiacritics(this.program).toLowerCase().replaceAll(' ', '-');

    final buffer = new StringBuffer();

    building.forEach((e) {
      if (e.length > 2) buffer.write(e[0]);
    });

    return {
      'register': this.register,
      'birthDate': this.fBirthDate,
      'campus': campus,
      'gender': this.gender.toLowerCase() == 'm' ? 'male' : 'female',
      'age': '$age',
      'program': program,
      'building': buffer.toString(),
    };
  }

  factory Profile.fromMap(Map<dynamic, dynamic> map) {
    return Profile(
      map['name'] as String,
      map['register'] as String,
      cra: map['cra'] as String,
      cumulativeCh: map['cumulativeCH'] as String,
      viewName: map['viewName'] as String,
      birthDate: map['birthDate'],
      campus: map['campus'] as String,
      gender: map['gender'] as String,
      program: map['program'] as String,
      building: map['building'] as String,
    );
  }

  @override
  String toString() =>
      '{ ${this.register}, ${this.viewName}, ${this.name}, ${this.cra}, ${this.cumulativeCh}, ${this.program}, ${this.campus}, ${this.building}, ${this.gender}, ${this.fBirthDate} }';
}
