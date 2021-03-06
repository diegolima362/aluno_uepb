import 'package:aluno_uepb/app/utils/format.dart';

class ProfileModel {
  final String register;
  final String name;
  String cra;
  String cumulativeCh;

  String viewName;
  final String birthDate;

  String program;
  String campus;
  String building;

  final String gender;

  ProfileModel(
    this.name,
    this.register, {
    this.cra: '-',
    this.cumulativeCh: '-',
    this.viewName: '',
    this.birthDate: '',
    this.campus: '',
    this.gender: '',
    this.program: '',
    this.building: '',
  });

  factory ProfileModel.fromMap(Map<dynamic, dynamic> map) {
    return ProfileModel(
      map['name'] as String,
      map['register'] as String,
      cra: map['cra'] as String,
      cumulativeCh: map['cumulativeCH'] as String,
      viewName: map['viewName'] as String,
      birthDate: map['birthDateEpoch'],
      campus: map['campus'] as String,
      gender: map['gender'] as String,
      program: map['program'] as String,
      building: map['building'] as String,
    );
  }

  int get age {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDateObj.year;
    int month1 = currentDate.month;
    int month2 = birthDateObj.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDateObj.day;
      if (day2 > day1) {
        age--;
      }
    }

    return age;
  }

  DateTime get birthDateObj {
    final now = DateTime.now();

    if (birthDate.isEmpty) return now;

    final date = int.tryParse(birthDate);

    if (date != null) return DateTime.fromMicrosecondsSinceEpoch(date);

    return now;
  }

  String get fBirthDate => Format.dateFirebase(birthDateObj).toString();

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'register': this.register,
      'cra': this.cra,
      'age': this.age,
      'cumulativeCH': this.cumulativeCh,
      'viewName': this.viewName,
      'birthDate': this.fBirthDate,
      'birthDateEpoch': this.birthDateObj.microsecondsSinceEpoch.toString(),
      'campus': this.campus,
      'gender': this.gender,
      'program': this.program,
      'building': this.building,
    };
  }

  Map<String, dynamic> toMapDB() {
    return {
      'name': this.name,
      'register': this.register,
      'age': this.age,
      'campus': this.campus,
      'gender': this.gender,
      'program': this.program,
      'building': this.building,
      'date': Format.dateFirebase(DateTime.now()),
    };
  }

  @override
  String toString() =>
      '{ ${this.register}, ${this.viewName}, ${this.name}, ${this.cra}, ${this.cumulativeCh}, ${this.program}, ${this.campus}, ${this.building}, ${this.gender}, ${this.fBirthDate} }';
}
