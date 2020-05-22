import 'package:erdm/models/course.dart';

class Profile {
  final String name;
  final String register;
  String cra;
  String cumulative_ch;

  String viewName;
  final DateTime birthDate;

  String program;
  String campus;

  String gender;

  List<Course> courses;

  Profile(this.name, this.register,
      {this.courses,
      this.cra = '-',
      this.cumulative_ch = '-',
      this.viewName,
      this.birthDate,
      this.campus,
      this.gender,
      this.program});

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

  String get fBirthDate => birthDate.toString().split(' ')[0];

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'register': this.register,
        'cra': this.cra,
        'age': this.cumulative_ch,
        'cumulative_ch': this.cumulative_ch,
        'viewName': this.viewName,
        'birthDate': this.fBirthDate,
        'campus': this.campus,
        'gender': this.gender,
        'program': this.program,
        'courses': this.courses
      };

  factory Profile.fromJson(dynamic json) {
    var coursesObjsJson = json['courses'] as List;

    List<Course> courses = coursesObjsJson
        .map((courseJson) => Course.fromJson(courseJson))
        .toList();

    List<String> date = (json['birthDate'] as String).split('-');
    DateTime birthDate = DateTime(
      int.parse(date[2]),
      int.parse(date[1]),
      int.parse(date[0]),
    );

    return Profile(
      json['name'] as String,
      json['register'] as String,
      courses: courses,
      cra: json['cra'] as String,
      cumulative_ch: json['cumulative_ch'] as String,
      viewName: json['viewName'] as String,
      birthDate: birthDate,
      campus: json['campus'] as String,
      gender: json['gender'] as String,
      program: json['program'] as String,
    );
  }

  @override
  String toString() =>
      '{ ${this.name}, ${this.register}, ${this.cra}, ${this.program}, ${this.campus}, ${this.gender}, ${this.fBirthDate}, ${this.courses} }';
}
