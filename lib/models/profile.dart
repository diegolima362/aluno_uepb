import 'package:erdm/models/course.dart';

class Profile {
  final String name;
  final String register;
  String cra;
  String cumulativeCh;

  String viewName;
  final DateTime birthDate;

  String program;
  String campus;

  String gender;

  List<Course> courses;

  Profile(this.name, this.register,
      {this.courses,
      this.cra = '-',
      this.cumulativeCh = '-',
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

  Map<String, dynamic> toMap() {
    final mapCourses = List<Map<dynamic, dynamic>>();
    this.courses.forEach((element) => mapCourses.add(element.toMap()));
    return {
      'name': this.name,
      'register': this.register,
      'cra': this.cra,
      'age': this.cumulativeCh,
      'cumulative_ch': this.cumulativeCh,
      'viewName': this.viewName,
      'birthDate': this.fBirthDate,
      'campus': this.campus,
      'gender': this.gender,
      'program': this.program,
      'courses': mapCourses,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    var coursesObjsJson = map['courses'] as List;

    List<Course> courses = coursesObjsJson
        .map((courseJson) => Course.fromMap(courseJson))
        .toList();

    List<String> date = (map['birthDate'] as String).split('-');
    DateTime birthDate = DateTime(
      int.parse(date[2]),
      int.parse(date[1]),
      int.parse(date[0]),
    );

    return Profile(
      map['name'] as String,
      map['register'] as String,
      courses: courses,
      cra: map['cra'] as String,
      cumulativeCh: map['cumulative_ch'] as String,
      viewName: map['viewName'] as String,
      birthDate: birthDate,
      campus: map['campus'] as String,
      gender: map['gender'] as String,
      program: map['program'] as String,
    );
  }

  @override
  String toString() =>
      '{ ${this.name}, ${this.register}, ${this.cra}, ${this.program}, ${this.campus}, ${this.gender}, ${this.fBirthDate}, ${this.courses} }';
}
