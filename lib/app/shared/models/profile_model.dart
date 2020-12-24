import 'package:aluno_uepb/app/utils/format.dart';

class ProfileModel {
  final String register;
  final String name;
  String cra;
  String cumulativeCh;

  String viewName;
  final String birthDateString;

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
    this.birthDateString: '',
    this.campus: '',
    this.gender: '',
    this.program: '',
    this.building: '',
  });

  DateTime get birthDate => birthDateString.isEmpty
      ? DateTime.now()
      : DateTime(
          int.tryParse(birthDateString[2]) ?? 0,
          int.tryParse(birthDateString[1]) ?? 0,
          int.tryParse(birthDateString[0]) ?? 0,
        );

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

  factory ProfileModel.fromMap(Map<dynamic, dynamic> map) {
    return ProfileModel(
      map['name'] as String,
      map['register'] as String,
      cra: map['cra'] as String,
      cumulativeCh: map['cumulativeCH'] as String,
      viewName: map['viewName'] as String,
      birthDateString: map['birthDate'],
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
