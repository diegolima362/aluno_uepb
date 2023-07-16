import '../../../shared/data/extensions/extensions.dart';

class Profile {
  final String register;
  final String name;
  final String program;
  final String campus;
  final String totalHours;
  final String credits;
  final List<AcademicIndex> academicIndexes;

  Profile({
    required this.register,
    required this.name,
    required this.program,
    required this.campus,
    required this.totalHours,
    required this.credits,
    this.academicIndexes = const [],
  });
}

class AcademicIndex {
  final String label;
  final String value;

  AcademicIndex({
    this.label = '',
    this.value = '',
  });
}

extension Formater on Profile {
  String get firstName => name.split(' ').first.toLowerCase().capitalFirst;

  String get initials => name
      .split(' ')
      .map((e) => e.substring(0, 1).toUpperCase())
      .take(2)
      .toList()
      .join();
}
